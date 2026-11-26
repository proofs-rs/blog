+++
title = "Announcing Proofs.rs: A Public Registry for Rust Formal Verification Results"
description = "Hi, folks! We’re very happy to introduce proofs.rs, a place to publish and explore formal verification results for Rust crates. There are some great tools…"
date = 2026-10-10T22:23:16Z
slug = "announcing-proofs-rs-a-public-registry-for-rust-formal-verification-results"
type = "posts"
author = "Yuichi Nishiwaki"
original_url = "https://proofs-rs.hashnode.dev/announcing-proofs-rs-a-public-registry-for-rust-formal-verification-results"
rss_guid = "https://proofs-rs.hashnode.dev/announcing-proofs-rs-a-public-registry-for-rust-formal-verification-results"
+++

Hi, folks!

We’re very happy to introduce [proofs.rs](https://proofs.rs), a place to publish and explore formal verification results for Rust crates.

## Why?

There are some great tools for formally verifying Rust code, such as Kani, Verus, and Creusot, but their verification results often stay buried in individual repositories, making them hard to discover when we’re trying to decide whether to trust a library.

We wanted to make those results easier to find, examine, and reuse as building blocks for establishing the correctness of larger systems.

## What does it do?

On proofs.rs, you can browse verification reports by crate and API, see what properties have been verified, and follow links to the GitHub repositories containing the verification code and supporting evidence.

Each report also has a comment section for questions and discussion. Why? Because, importantly, proofs.rs doesn’t (or rather, cannot) certify that a crate is safe. Formal verification results come with assumptions, limitations, and sometimes subtle details that matter. Understanding what a result actually guarantees requires careful review. That’s why proofs.rs is designed around sharing evidence and enabling discussion, rather than issuing certifications.

## How to use it?

Publishing a report is pretty straightforward:

1. Fork a Rust crate on GitHub.
1. Add verification annotations to your fork.
1. Run cargo-proofs to submit your report.

That’s it!

Partial proofs are very welcome. You don’t need to verify every API or every property. Even a small, well-scoped result can be useful to someone, and perhaps one day, someone will build on your work to verify the entire crate.

As an example, we’ve verified [the itoa crate](https://crates.io/crates/itoa/1.0.18) and published [the results](https://proofs.rs/report/4) on proofs.rs. Feel free to take a look!

## What’s next?

We’d love to see formal verification become one more piece of information people can use when choosing software dependencies. Over time, we hope these results can also be composed and reused to establish stronger guarantees for larger systems built from verified components.

proofs.rs is still in a very early beta stage, so there may be bugs and rough edges in the user experience. Feedback, suggestions, and contributions are always appreciated.

Right now, cargo-proofs supports Kani and Creusot. If you’re using or developing another verification tool, we’d be happy to hear about it. Requests for additional tool support are very welcome!

Thank you!

[https://proofs.rs](https://proofs.rs)
