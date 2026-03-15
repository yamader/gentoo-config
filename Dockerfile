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
	emerge -1j dev-lang/rust:1.86.0
	emerge -cX dev-lang/rust:1.86.0

	USE=d emerge -1j sys-devel/gcc:11
EOS
RUN --mount=type=cache,target=/var/db/repos --mount=type=cache,target=/var/cache/distfiles --mount=type=tmpfs,target=/var/tmp/portage <<-EOS
	wget -O- https://github.com/gentoo-mirror/guru/archive/master.tar.gz | tar xzC /var/db/repos
	wget -O- https://github.com/gentoo/dlang/archive/master.tar.gz | tar xzC /var/db/repos
	mkdir -p /etc/portage/repos.conf
	cat > /etc/portage/repos.conf/bootstrap.conf <<-EOF
		[guru]
		location = /var/db/repos/guru-master
		[dlang]
		location = /var/db/repos/dlang-master
	EOF

	ACCEPT_KEYWORDS=~amd64 USE=dlang_single_target_gdc-14 emerge -1j dev-lang/ldc2
	ACCEPT_KEYWORDS=~amd64 emerge -1j dev-lang/swift
EOS

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
