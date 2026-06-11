/*
 * libparam linker script fragment
 * Collects all param.* sections for parameter discovery
 */

SECTION_PROLOGUE(param,,)
{
	__start_param = .;
	KEEP(*(SORT_BY_NAME(param.*)))
	__stop_param = .;
} GROUP_DATA_LINK_IN(ROMABLE_REGION, ROMABLE_REGION)
