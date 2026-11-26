+++
title = "lean-miri: Formally Proving Rust Programs Free of Undefined Behavior with Lean"
description = "Miri is an interpreter for Rust’s Mid-level Intermediate Representation (MIR) that detects undefined behavior (UB). It supports a wide range of Rust…"
date = 2026-11-03T14:24:37Z
slug = "lean-miri-formally-proving-rust-programs-free-of-undefined-behavior-with-lean"
type = "posts"
author = "Yuichi Nishiwaki"
original_url = "https://proofs-rs.hashnode.dev/lean-miri-formally-proving-rust-programs-free-of-undefined-behavior-with-lean"
rss_guid = "https://proofs-rs.hashnode.dev/lean-miri-formally-proving-rust-programs-free-of-undefined-behavior-with-lean"
+++

Miri is an interpreter for Rust’s Mid-level Intermediate Representation (MIR) that detects undefined behavior (UB). It supports a wide range of Rust language features, including advanced traits and raw pointer operations, and implements state-of-the-art memory models. This broad coverage makes Miri a practical and widely used tool for detecting UB in real-world Rust code.

While dynamic execution tools like Miri are invaluable for catching bugs during testing, proving that a program is free of Undefined Behavior (UB-freedom) across all valid inputs or thread schedules generally requires formal verification. Tools like Aeneas and Creusot provide such great verification pipelines for Rust, but fully formalizing low-level execution semantics still remains a big challenge.

To explore whether we can leverage Miri's existing, highly comprehensive execution model for mathematical proofs, we built [lean-miri](https://github.com/proofs-rs/lean-miri), an experimental port of the Miri interpreter into the Lean 4 theorem prover.

By running Miri’s exact operational semantics inside Lean 4, we can write and check formal proofs of UB-freedom for Rust programs directly against Miri’s unsafe semantics.

## Why Port Miri to Lean?

Building a standalone formal semantics, as done in many existing verification tools, often involves trading off language coverage, making it difficult to handle complex traits or advanced language constructs.

Miri already provides the most complete operational model of Rust in practice. By porting Miri to Lean 4 instead of defining another semantics from scratch, we get a verifier based directly on Rust’s reference execution model.

The core objective is straightforward: given a Rust program $P$ and the interpreted Miri state \(\mathcal{M}\) in Lean 4, prove the following property as a theorem:

$$\forall i : \text{input}, \quad \text{valid}(i) \implies \mathcal{M}(P, i) \neq \text{UB}$$

## Proving Undefined Behavior-Freedom

So far, we have been working on proving UB-freedom for some concrete programs:

### 1. A trivial safe function

```rust
fn empty_function() {}
```

Even for an empty function, verifying state transitions through the full Miri evaluation loop is non-trivial and served as an essential baseline for the core architecture.

### 2. A realistic function with `unsafe` (`duplicate_prefix`)

A function that duplicates the first $n$ bytes of a buffer into the following $n$ bytes:

```rust
/// Duplicate the first `n` bytes into the following `n` bytes.
pub fn duplicate_prefix(buf: &mut [u8], n: usize) -> bool {
    if n == 0 {
        return true;
    }
    if n > buf.len() / 2 {
        return false;
    }
    let p = buf.as_mut_ptr();
    unsafe {
        std::ptr::copy_nonoverlapping(p, p.add(n), n);
    }
    true
}
```

This serves as a practical test case involving pointer arithmetic, bounds checking, and an `unsafe` block. References in the target program are treated under the Tree Borrows semantics.

For both programs, we have formally proven in Lean the safety under Miri's operational semantics (with Tree Borrows).

```lean
-- The empty function does not have undefined behavior.
theorem noUB
    (s : Static)
    (metadata : Metadata s)
    (profile : Profile s)
    (p : Packet)
    (runtime : RuntimeProfile s p)
    (input : InputDraft.CurrentInputDraft s p) :
    CallLevelNoUB.NoUB s p
```

## A bug in Miri

While verifying state transitions related to Tree Borrows in Lean 4, we encountered a subtle edge case that resulted in an internal assertion failure in Miri. We reported this finding to the developers as [**Issue #5543**](https://github.com/rust-lang/miri/issues/5543).

## Challenges & Current Limitations

While our porting already covers most of the original interpreter, the current codebase and experiments face several challenges:

1. The Lean implementation of the interpreter is currently unoptimized. Workloads that run quickly in native Miri take significantly longer inside Lean, which directly impacts proof elaboration and build times. For the second example above, it takes over 2 hours to check the validity of the proof.
1. To evaluate MIR accurately, the exported data includes `rustc` layout and sizing metadata for all relevant standard library types. This inflates exported program payloads to ~500MiB, adding overhead to the evaluation process.
1. `lean-miri` currently operates as a forward-execution step interpreter. Without a dedicated program logic (such as a weakest precondition calculus), verification requires manually inferring and structuring intermediate lemmas, which scales proof complexity.
1. To keep initial verification tractable, features like garbage collection and data race detection within the interpreter were disabled during current experimental runs. Enabling full data race checking to verify liveness across arbitrary thread schedules remains work in progress.
1. We lack a large, well-designed theorem library for proving various properties of the interpreter and its execution traces. To make verification of larger programs practical, we need to avoid repeatedly proving basic results and instead reuse established lemmas from the framework. The proof of the second example, for instance, currently consists of over 700,000 lines of Lean code and is essentially an unmaintainable mess. It will need substantial refactoring around a well-designed program logic and a reusable library of lemmas.

## What’s Next?

`lean-miri` is still an early-stage experiment, not a push-button verifier for arbitrary Rust code. We have a lot of refactoring and optimization work ahead. In particular, designing a nice program logic and building a useful library of lemmas should be a very interesting challenge.

If you are interested in our development, check out the repository! Feedback, contributions, and discussions are all very welcome.

GitHub: [https://github.com/proofs-rs/lean-miri](https://github.com/proofs-rs/lean-miri)
