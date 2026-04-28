all: verify_combine

verify_combine:
	./verify_combine_sigs -a ${EFI_ARCH} shim*$(EFI_ARCH).efi*signed*
