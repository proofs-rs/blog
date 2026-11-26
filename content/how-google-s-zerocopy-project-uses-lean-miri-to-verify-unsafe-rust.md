+++
title = "How Google's zerocopy Project Uses lean-miri to Verify Unsafe Rust"
description = "lean-miri was recently adopted by Anneal, a Rust verification framework developed inside the zerocopy repository. Following this adoption, a pull request…"
date = 2026-11-24T14:12:30Z
slug = "how-google-s-zerocopy-project-uses-lean-miri-to-verify-unsafe-rust"
type = "posts"
author = "Yuichi Nishiwaki"
original_url = "https://proofs-rs.hashnode.dev/how-google-s-zerocopy-project-uses-lean-miri-to-verify-unsafe-rust"
rss_guid = "https://proofs-rs.hashnode.dev/how-google-s-zerocopy-project-uses-lean-miri-to-verify-unsafe-rust"
+++

lean-miri was recently adopted by Anneal, a Rust verification framework developed inside the zerocopy repository. Following this adoption, a pull request from Anneal’s creator, Josh Liebow-Feeser, has already been merged into lean-miri.

[lean-miri](https://proofs-rs.github.io/lean-miri/) ports Rust’s Miri interpreter to Lean. Rather than running lean-miri directly as an end-to-end verifier, Anneal uses its MIR execution model as a reference semantics. Proofs in Anneal show that individual operations in Anneal’s own model correspond to the matching operations in lean-miri.

The core challenge for a framework like Anneal is ensuring that its abstract proof model remains sound with respect to Rust’s actual execution semantics—including edge cases around uninitialized memory, provenance, and byte-level layouts. Building and maintaining a formal Rust semantics from scratch to anchor that model would be prohibitively expensive. Using lean-miri as a ground-truth specification solves this by grounding Anneal’s tractable proof model directly in Miri’s concrete behavior.

Integrating an executable interpreter into real proofs exposed a clear gap: running an operation is different from proving properties about it ([zerocopy issue #4009](https://github.com/google/zerocopy/issues/4009)). Anneal needed specification and frame lemmas for memory operations—such as how written bytes change and that untouched ranges stay intact—without repeatedly unfolding the interpreter’s internal representation. Josh contributed those lemmas upstream in [lean-miri PR #91](https://github.com/proofs-rs/lean-miri/pull/91), and driving improvements through real downstream use cases like this is a great way for the project to evolve.

This integration points to a clear direction for lean-miri: it should serve not just as an executable reference, but as a practical foundation that other verification tools can build proofs on top of. If you are building verification tooling for Rust and need a formal baseline, try out lean-miri and let us know what is missing. Thanks to Josh for the contribution.
