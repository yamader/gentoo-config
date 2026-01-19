FROM gentoo
RUN --mount=type=cache,target=/var/db/repos emerge-webrsync

# additional bootstrap
RUN --mount=type=cache,target=/var/db/repos --mount=type=cache,target=/var/cache/distfiles --mount=type=tmpfs,target=/var/tmp/portage <<-EOS
	mkdir -p /etc/portage/patches/llvm-core/llvm:17
	cat > /etc/portage/patches/llvm-core/llvm:17/fix-for-clang.patch <<-EOF
		--- a/llvm/tools/sancov/sancov.cpp
		+++ b/llvm/tools/sancov/sancov.cpp
		@@ -508,1 +508,1 @@
		-    return SpecialCaseList::createOrDie({{ClIgnorelist}},
		+    return SpecialCaseList::createOrDie({ClIgnorelist},
	EOF
	USE=mrustc-bootstrap emerge -1j dev-lang/rust:1.74.1
	emerge -j dev-lang/rust
	emerge -c
	emerge -W dev-lang/rust
EOS
RUN --mount=type=cache,target=/var/db/repos --mount=type=cache,target=/var/cache/distfiles --mount=type=tmpfs,target=/var/tmp/portage \
	USE=d CC=gcc CXX=g++ emerge -1j sys-devel/gcc

# fix system
RUN --mount=type=cache,target=/var/db/repos --mount=type=cache,target=/var/cache/distfiles --mount=type=tmpfs,target=/var/tmp/portage \
	emerge -1j dev-vcs/git sys-devel/mold

# fix profile
RUN --mount=type=cache,target=/var/db/repos --mount=type=cache,target=/var/cache/distfiles --mount=type=tmpfs,target=/var/tmp/portage \
	ACCEPT_KEYWORDS=~amd64 USE=-* emerge -1j \
		dev-lang/python:3.14t \
		media-libs/harfbuzz \
		media-libs/libwebp \
		media-video/ffmpeg
