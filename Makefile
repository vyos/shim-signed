all: verify

verify: verify_$(EFI_ARCH)

verify_:
	@echo "EFI_ARCH is not set, ABORT"
	@false

verify_x64 verify_ia32:
	mkdir -p build
	# Verifying that the image is signed with the correct key.
	sbverify --cert MicCorUEFCA2011_2011-06-27.crt shim$(EFI_ARCH).efi.signed
	# Verifying that we have the correct binary.
	sbattach --detach build/detached-sig shim$(EFI_ARCH).efi.signed 
	cp /usr/lib/shim/shim$(EFI_ARCH).efi build/shim$(EFI_ARCH).efi.signed
	sbattach --attach build/detached-sig build/shim$(EFI_ARCH).efi.signed
	cmp shim$(EFI_ARCH).efi.signed build/shim$(EFI_ARCH).efi.signed
	sha256sum shim$(EFI_ARCH).efi.signed build/shim$(EFI_ARCH).efi.signed

verify_aa64:
	@echo "Copying unsigned arm64 shim into place, sorry :-("
	mkdir -p build
	cp shimaa64.efi.OLD.HACK build/shim$(EFI_ARCH).efi.signed

clean:
	rm -rf build
