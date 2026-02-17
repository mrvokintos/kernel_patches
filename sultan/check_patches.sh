#!/bin/bash

# Скрипт для проверки, какие патчи нужно применить к ядру Sultan

KERNEL_DIR="${1:-../android_kernel_google_tensynos}"
PATCH_DIR="$(dirname "$0")"

echo "=== Проверка патчей для Sultan Kernel ==="
echo "Директория ядра: $KERNEL_DIR"
echo ""

# Проверка наличия KernelSU
if [ -d "$KERNEL_DIR/KernelSU-Next" ] || [ -d "$KERNEL_DIR/KernelSU" ]; then
    echo "✓ KernelSU найден"
else
    echo "✗ KernelSU не найден - сначала интегрируйте KernelSU"
    exit 1
fi

# Проверка наличия SUSFS
if [ -f "$KERNEL_DIR/fs/susfs.c" ]; then
    echo "✓ SUSFS найден"
else
    echo "✗ SUSFS не найден - сначала интегрируйте SUSFS"
    exit 1
fi

echo ""
echo "=== Проверка патчей ==="

# Проверка base.c
if grep -q "CONFIG_KSU_SUSFS_SUS_MAP" "$KERNEL_DIR/fs/proc/base.c" 2>/dev/null; then
    echo "✓ fix_base.c.patch уже применен"
else
    echo "✗ fix_base.c.patch нужно применить"
    echo "  Команда: cd $KERNEL_DIR && patch -p1 < $PATCH_DIR/fix_base.c.patch"
fi

# Проверка sys.c
if grep -q "susfs_spoof_uname" "$KERNEL_DIR/kernel/sys.c" 2>/dev/null; then
    echo "✓ sys.c_fix.patch уже применен"
else
    echo "✗ sys.c_fix.patch нужно применить"
    echo "  Команда: cd $KERNEL_DIR && patch -p1 < $PATCH_DIR/sys.c_fix.patch"
fi

echo ""
echo "=== Проверка завершена ==="
