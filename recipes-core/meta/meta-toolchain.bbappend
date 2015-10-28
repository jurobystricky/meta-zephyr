

create_sdk_files_append_zephyr() {

	rm -fv ${SDK_OUTPUT}/${SDKPATH}/site-config-*
	# rm -f ${SDK_OUTPUT}/${SDKPATH}/environment-setup-*
	# rm -fv ${SDK_OUTPUT}/${SDKPATH}/version-*

	rm -rfv ${SDK_OUTPUT}/${SDKPATH}/sysroots/${MULTIMACH_TARGET_SYS}/etc
	rm -rfv ${SDK_OUTPUT}/${SDKPATH}/sysroots/${MULTIMACH_TARGET_SYS}/var
	rm -rfv ${SDK_OUTPUT}/${SDKPATH}/sysroots/${MULTIMACH_TARGET_SYS}/run
	rm -rfv ${SDK_OUTPUT}/${SDKPATH}/sysroots/${MULTIMACH_TARGET_SYS}/lib
}


