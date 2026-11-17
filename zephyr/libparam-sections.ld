/*
 * libparam linker script fragment for Zephyr
 *
 * libparam discovers statically defined objects by walking linker sections
 * delimited by __start_<sec> / __stop_<sec> symbols. All of these objects are
 * declared const, so they are placed in ROM.
 *
 *   param.*        - PARAM_DEFINE_STATIC_*() / PARAM_DEFINE_REMOTE()  (param_list.c)
 *   vmem           - VMEM_DEFINE_*()                                  (vmem.c)
 *   vmem_bdevice   - VMEM_DEFINE_BLOCK_DEVICE()                       (vmem_block.c)
 *   param_publish  - user supplied publish queue pointers             (param_server.c)
 *
 * SPDX-License-Identifier: MIT
 */

SECTION_PROLOGUE(param,,SUBALIGN(8))
{
	__start_param = .;
	KEEP(*(SORT_BY_NAME(param.*)))
	__stop_param = .;
} GROUP_ROM_LINK_IN(ROMABLE_REGION, ROMABLE_REGION)

SECTION_PROLOGUE(vmem,,SUBALIGN(8))
{
	__start_vmem = .;
	KEEP(*(vmem))
	__stop_vmem = .;
} GROUP_ROM_LINK_IN(ROMABLE_REGION, ROMABLE_REGION)

SECTION_PROLOGUE(vmem_bdevice,,SUBALIGN(8))
{
	__start_vmem_bdevice = .;
	KEEP(*(vmem_bdevice))
	__stop_vmem_bdevice = .;
} GROUP_ROM_LINK_IN(ROMABLE_REGION, ROMABLE_REGION)

SECTION_PROLOGUE(param_publish,,SUBALIGN(4))
{
	__start_param_publish = .;
	KEEP(*(param_publish))
	__stop_param_publish = .;
} GROUP_ROM_LINK_IN(ROMABLE_REGION, ROMABLE_REGION)
