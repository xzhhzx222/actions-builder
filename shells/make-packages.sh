#!/bin/bash
#==========================================================================
# https://github.com/xzhhzx222/actions-builder
#==========================================================================

echo "::group::bash ${DIY_P1_SH}"
bash "${DIY_P1_SH}"
echo "::endgroup::"

echo "::group::custom directory list"
ls -lah "${CUSTOM_DIR}/" 2>/dev/null || echo "No ${CUSTOM_DIR} directory found."
echo "::endgroup::"

echo "::group::feeds update"
./scripts/feeds update -a
echo "::endgroup::"

echo "::group::feeds install luci-base"
./scripts/feeds install luci-base
echo "::endgroup::"

for pkg_name in "${CUSTOM_DIR}"/*/; do
  echo "::group::feeds install $(basename "${pkg_name}")"
  ./scripts/feeds install "$(basename "${pkg_name}")"
  echo "::endgroup::"
done

echo "::group::bash ${DIY_P2_SH}"
bash "${DIY_P2_SH}"
echo "::endgroup::"

echo "::group::make defconfig"
cp -vf "${CONFIG_FILE}" .config
make defconfig
echo "::endgroup::"

echo "::group::compile po2lmo"
sudo make -C "${CUSTOM_DIR}/luci-app-openclash/tools/po2lmo" install
echo "::endgroup::"

for pkg_name in "${CUSTOM_DIR}"/*/; do
  echo "::group::complie ${pkg_name} with $(nproc) threads"
  make ${pkg_name}compile -j$(($(nproc) + 1)) || \
  make ${pkg_name}compile -j1 V=s
  echo "::endgroup::"
done
