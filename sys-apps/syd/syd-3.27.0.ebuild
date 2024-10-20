# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

RESTRICT="test" # fails with sandbox

CRATES="
	addr2line@0.24.2
	adler2@2.0.0
	ahash@0.8.11
	aho-corasick@1.1.3
	android-tzdata@0.1.1
	android_system_properties@0.1.5
	anes@0.1.6
	anstream@0.6.15
	anstyle-parse@0.2.5
	anstyle-query@1.1.1
	anstyle-wincon@3.0.4
	anstyle@1.0.8
	anyhow@1.0.89
	argv@0.1.11
	arrayvec@0.7.6
	autocfg@1.4.0
	backtrace@0.3.74
	bitflags@1.3.2
	bitflags@2.6.0
	bumpalo@3.16.0
	caps@0.5.5
	cast@0.3.0
	cc@1.1.29
	cfg-if@1.0.0
	cfg_aliases@0.1.1
	cfg_aliases@0.2.1
	chrono@0.4.38
	ciborium-io@0.2.2
	ciborium-ll@0.2.2
	ciborium@0.2.2
	clap@4.5.20
	clap_builder@4.5.20
	clap_derive@4.5.18
	clap_lex@0.7.2
	colorchoice@1.0.2
	core-foundation-sys@0.8.7
	crc32fast@1.4.2
	criterion-plot@0.5.0
	criterion@0.5.1
	crunchy@0.2.2
	cty@0.2.2
	darling@0.20.10
	darling_core@0.20.10
	darling_macro@0.20.10
	derive_builder@0.20.2
	derive_builder_core@0.20.2
	derive_builder_macro@0.20.2
	dirs-sys@0.4.1
	dirs@5.0.1
	either@1.13.0
	equivalent@1.0.1
	errno@0.3.9
	error-chain@0.12.4
	expiringmap@0.1.2
	fastrand@2.1.1
	fixedbitset@0.5.7
	flate2@1.0.34
	fnv@1.0.7
	futures-channel@0.3.31
	futures-core@0.3.31
	futures-executor@0.3.31
	futures-io@0.3.31
	futures-macro@0.3.31
	futures-sink@0.3.31
	futures-task@0.3.31
	futures-util@0.3.31
	futures@0.3.31
	getargs@0.5.0
	getrandom@0.2.15
	getset@0.1.3
	gimli@0.31.1
	goblin@0.8.2
	gperftools@0.2.0
	half@2.4.1
	hashbrown@0.12.3
	hashbrown@0.14.5
	heck@0.5.0
	hermit-abi@0.3.9
	hermit-abi@0.4.0
	hex-conservative@0.2.1
	hex@0.4.3
	home@0.5.9
	iana-time-zone-haiku@0.1.2
	iana-time-zone@0.1.61
	ident_case@1.0.1
	indexmap@1.9.3
	indexmap@2.5.0
	io-uring@0.6.4
	ipnet@2.10.1
	iprange@0.6.7
	is-terminal@0.4.13
	is_terminal_polyfill@1.70.1
	itertools@0.10.5
	itoa@1.0.11
	js-sys@0.3.72
	lazy_static@1.5.0
	lexis@0.2.3
	libc@0.2.159
	libcgroups@0.4.1
	libcontainer@0.4.1
	libloading@0.8.5
	liboci-cli@0.4.1
	libredox@0.1.3
	libseccomp-sys@0.2.1
	libseccomp@0.3.0
	linux-raw-sys@0.4.14
	lock_api@0.4.12
	log@0.4.22
	md5@0.7.0
	memchr@2.7.4
	memoffset@0.9.1
	mimalloc2-rust-sys@2.1.7-source
	mimalloc2-rust@0.3.2
	miniz_oxide@0.8.0
	nc@0.9.4
	nix@0.28.0
	nix@0.29.0
	nonempty@0.10.0
	nu-ansi-term@0.46.0
	num-traits@0.2.19
	num_cpus@1.16.0
	object@0.36.5
	oci-spec@0.6.8
	once_cell@1.19.0
	oorandom@11.1.4
	option-ext@0.2.0
	overload@0.1.1
	parking_lot@0.12.3
	parking_lot_core@0.9.10
	parse-size@1.0.0
	pin-project-lite@0.2.14
	pin-utils@0.1.0
	pkg-config@0.3.31
	plain@0.2.3
	prctl@1.0.0
	proc-macro-error-attr2@2.0.0
	proc-macro-error2@2.0.1
	proc-macro2@1.0.87
	procfs-core@0.16.0
	procfs@0.16.0
	protobuf-codegen@3.2.0
	protobuf-parse@3.2.0
	protobuf-support@3.2.0
	protobuf@3.2.0
	quick_cache@0.6.9
	quote@1.0.37
	redox_syscall@0.5.7
	redox_users@0.4.6
	regex-automata@0.4.8
	regex-syntax@0.8.5
	regex@1.10.6
	rs_hasher_ctx@0.1.3
	rs_internal_hasher@0.1.3
	rs_internal_state@0.1.3
	rs_n_bit_words@0.1.3
	rs_sha1@0.1.3
	rs_sha3_256@0.1.2
	rs_sha3_384@0.1.2
	rs_sha3_512@0.1.2
	rust-criu@0.4.0
	rustc-demangle@0.1.24
	rustc-hash@2.0.0
	rustix@0.38.37
	rustversion@1.0.17
	ryu@1.0.18
	safe-path@0.1.0
	same-file@1.0.6
	scopeguard@1.2.0
	scroll@0.12.0
	scroll_derive@0.12.0
	sendfd@0.4.3
	serde@1.0.210
	serde_derive@1.0.210
	serde_json@1.0.128
	sharded-slab@0.1.7
	shellexpand@3.1.0
	shlex@1.3.0
	slab@0.4.9
	smallvec@1.13.2
	strsim@0.11.1
	strum@0.26.3
	strum_macros@0.26.4
	syn@2.0.79
	tabwriter@1.4.0
	tcmalloc@0.3.0
	tempfile@3.13.0
	thiserror-impl@1.0.64
	thiserror@1.0.64
	thread_local@1.1.8
	tick_counter@0.4.5
	tinytemplate@1.2.1
	tracing-attributes@0.1.27
	tracing-core@0.1.32
	tracing-log@0.2.0
	tracing-subscriber@0.3.18
	tracing@0.1.40
	unicode-ident@1.0.13
	unicode-width@0.1.14
	utf8parse@0.2.2
	valuable@0.1.0
	version_check@0.9.5
	walkdir@2.5.0
	wasi@0.11.0+wasi-snapshot-preview1
	wasm-bindgen-backend@0.2.95
	wasm-bindgen-macro-support@0.2.95
	wasm-bindgen-macro@0.2.95
	wasm-bindgen-shared@0.2.95
	wasm-bindgen@0.2.95
	which@4.4.2
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-util@0.1.9
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
	windows-core@0.52.0
	windows-sys@0.48.0
	windows-sys@0.52.0
	windows-sys@0.59.0
	windows-targets@0.48.5
	windows-targets@0.52.6
	windows_aarch64_gnullvm@0.48.5
	windows_aarch64_gnullvm@0.52.6
	windows_aarch64_msvc@0.48.5
	windows_aarch64_msvc@0.52.6
	windows_i686_gnu@0.48.5
	windows_i686_gnu@0.52.6
	windows_i686_gnullvm@0.52.6
	windows_i686_msvc@0.48.5
	windows_i686_msvc@0.52.6
	windows_x86_64_gnu@0.48.5
	windows_x86_64_gnu@0.52.6
	windows_x86_64_gnullvm@0.48.5
	windows_x86_64_gnullvm@0.52.6
	windows_x86_64_msvc@0.48.5
	windows_x86_64_msvc@0.52.6
	zerocopy-derive@0.7.35
	zerocopy@0.7.35
"

inherit cargo

DESCRIPTION="seccomp and landlock based application sandbox with support for namespaces"
HOMEPAGE="https://sydbox.exherbolinux.org"
SRC_URI="https://git.sr.ht/~alip/syd/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${CARGO_CRATE_URIS}
"

IUSE="static"

LICENSE="GPL-3+"
# Dependent crate licenses
LICENSE+=" Apache-2.0 MIT Unicode-DFS-2016"

SLOT="0"
KEYWORDS="~amd64"

DEPEND="static? ( sys-libs/libseccomp[static-libs] )
	sys-libs/libseccomp"
RDEPEND="${DEPEND}"

S="${WORKDIR}/syd-v${PV}"

src_configure() {
	if use static; then
		export LIBSECCOMP_LINK_TYPE="static"
		export LIBSECCOMP_LIB_PATH=$(pkgconf --variable=libdir libseccomp)
		export RUSTFLAGS+="-Clink-args=-static -Clink-args=-no-pie -Clink-args=-Wl,-Bstatic -Ctarget-feature=+crt-static"
		local myfeatures=( "log,uring,utils" )
		cargo_src_configure --no-default-features
	else
		local myfeatures=( "oci" )
		cargo_src_configure
	fi
}

src_install () {
	cargo_src_install
	dodoc README.md
	insinto /usr/libexec
	doins src/esyd.sh

	insinto /etc
	newins data/user.syd-3 user.syd-3.sample

	insinto /usr/share/vim/vimfiles/ftdetect
	doins vim/ftdetect/syd.vim
	insinto /usr/share/vim/vimfiles/syntax
	doins vim/syntax/syd-3.vim
}

src_test() {
	RUSTFLAGS="" cargo_src_test
}
