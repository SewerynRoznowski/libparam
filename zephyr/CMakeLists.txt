if(CONFIG_LIBPARAM)

  # Generate configuration header
  set(PARAM_HAVE_SYS_QUEUE OFF)
  if(CONFIG_PARAM_LIST_DYNAMIC OR (CONFIG_PARAM_LIST_POOL GREATER 0))
    set(PARAM_HAVE_SYS_QUEUE ON)
  endif()

  set(PARAM_LIST_DYNAMIC ${CONFIG_PARAM_LIST_DYNAMIC})
  set(PARAM_LIST_POOL ${CONFIG_PARAM_LIST_POOL})
  set(PARAM_HAVE_TIMESTAMP ${CONFIG_PARAM_HAVE_TIMESTAMP})
  set(PARAM_VMEM_64_BITS_API 1)

  set(MPACK_FLOAT 1)
  if(NOT CONFIG_PARAM_HAVE_FLOAT)
    set(MPACK_FLOAT 0)
  endif()

  set(MPACK_STDIO 0)
  if(CONFIG_PARAM_HAVE_FOPEN)
    if(CONFIG_PARAM_LIST_DYNAMIC)
      set(MPACK_STDIO 1)
    else()
      message(WARNING "PARAM_HAVE_FOPEN requires PARAM_LIST_DYNAMIC, disabling MPACK_STDIO")
    endif()
  endif()

  configure_file(
    ${ZEPHYR_CURRENT_MODULE_DIR}/zephyr/libparam.h.in
    ${CMAKE_CURRENT_BINARY_DIR}/include/libparam.h
  )

  # Source files
  zephyr_library_named(param)
  
  zephyr_library_sources(
    ${ZEPHYR_CURRENT_MODULE_DIR}/src/param/list/param_list.c
    ${ZEPHYR_CURRENT_MODULE_DIR}/src/param/param_client.c
    ${ZEPHYR_CURRENT_MODULE_DIR}/src/param/param_serializer.c
    ${ZEPHYR_CURRENT_MODULE_DIR}/src/param/param_server.c
    ${ZEPHYR_CURRENT_MODULE_DIR}/src/param/param_string.c
    ${ZEPHYR_CURRENT_MODULE_DIR}/src/param/param_queue.c
    ${ZEPHYR_CURRENT_MODULE_DIR}/src/param/param_wildcard.c
    ${ZEPHYR_CURRENT_MODULE_DIR}/src/param/param.c
    ${ZEPHYR_CURRENT_MODULE_DIR}/src/mpack/mpack.c
    ${ZEPHYR_CURRENT_MODULE_DIR}/src/vmem/vmem_client.c
    ${ZEPHYR_CURRENT_MODULE_DIR}/src/vmem/vmem_crc32.c
    ${ZEPHYR_CURRENT_MODULE_DIR}/src/vmem/vmem_server.c
    ${ZEPHYR_CURRENT_MODULE_DIR}/src/vmem/vmem.c
    ${ZEPHYR_CURRENT_MODULE_DIR}/src/vmem/vmem_block.c
  )

  if(CONFIG_PARAM_HAVE_FOPEN)
    zephyr_library_sources(
      ${ZEPHYR_CURRENT_MODULE_DIR}/src/vmem/vmem_file.c
      ${ZEPHYR_CURRENT_MODULE_DIR}/src/vmem/vmem_mmap.c
    )
  endif()

  if(CONFIG_PARAM_VMEM_FRAM)
    zephyr_library_sources(
      ${ZEPHYR_CURRENT_MODULE_DIR}/src/vmem/vmem_fram.c
      ${ZEPHYR_CURRENT_MODULE_DIR}/src/vmem/vmem_fram_cache.c
    )
  endif()

  if(CONFIG_PARAM_COLLECTOR)
    zephyr_library_sources(
      ${ZEPHYR_CURRENT_MODULE_DIR}/src/param/collector/param_collector_config.c
      ${ZEPHYR_CURRENT_MODULE_DIR}/src/param/collector/param_collector.c
    )
  endif()

  # Include directories
  zephyr_library_include_directories(
    ${ZEPHYR_CURRENT_MODULE_DIR}/include
    ${CMAKE_CURRENT_BINARY_DIR}/include
  )

  # Link with CSP
  zephyr_library_link_libraries(csp)

  # Make headers available to applications
  zephyr_interface_library_named(libparam)
  target_include_directories(libparam INTERFACE 
    ${ZEPHYR_CURRENT_MODULE_DIR}/include
    ${CMAKE_CURRENT_BINARY_DIR}/include
  )

  # Add linker script for parameter section handling
  zephyr_linker_sources(SECTIONS ${ZEPHYR_CURRENT_MODULE_DIR}/zephyr/libparam-sections.ld)

endif()
