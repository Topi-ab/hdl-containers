# Authors:
#   Unai Martinez-Corral
#     <umartinezcorral@antmicro.com>
#     <unai.martinezcorral@ehu.eus>
#
# Copyright Unai Martinez-Corral
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

#ARG REGISTRY='gcr.io/hdl-containers/debian/bullseye'
ARG REGISTRY='anybytes/debian-bullseye'
#---

# WORKAROUND: this is required because 'COPY --from' does not support ARGs
FROM $REGISTRY/pkg/nvc AS pkg-nvc
FROM $REGISTRY/pkg/verilator AS pkg-verilator
FROM $REGISTRY/pkg/iverilog AS pkg-iverilog

FROM $REGISTRY/ghdl/llvm AS base

COPY --from=pkg-nvc /nvc /
COPY --from=pkg-verilator /verilator /
COPY --from=pkg-iverilog /iverilog /

RUN apt-get update -qq \
 && DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    binutils \
    libdw1 \
    libzstd1 \
    make \
    perl \
    python3-pip \
    tcl \
 && apt-get autoclean && apt-get clean && apt-get -y autoremove \
 && rm -rf /var/lib/apt/lists/*
