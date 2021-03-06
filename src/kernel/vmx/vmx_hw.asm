global _cpuid
_cpuid:
	push ebx
	push ecx
	push edx
	push edi

	mov eax, 1
	cpuid

	mov edi, [esp+20]
	mov dword [edi], eax
	add edi, 4
	mov dword [edi], ebx
	add edi, 4
	mov dword [edi], ecx
	add edi, 4
	mov dword [edi], edx

	pop edi
	pop edx
	pop ecx
	pop ebx
	ret

;; READ CONTROL REGISTERS

global _vmx_read_cr0
_vmx_read_cr0:
	mov eax, cr0
	ret

global _vmx_read_cr2
_vmx_read_cr2:
	mov eax, cr2
	ret

global _vmx_read_cr3
_vmx_read_cr3:
	mov eax, cr3
	ret

global _vmx_read_cr4
_vmx_read_cr4:
	mov eax, cr4
	ret

;; WRITE CONTROL REGISTERS

global _vmx_write_cr0
_vmx_write_cr0:
	mov eax, [esp+4]
	mov cr0, eax
	ret

global _vmx_write_cr3
_vmx_write_cr3:
	mov eax, [esp+4]
	mov cr3, eax
	ret

global _vmx_write_cr4
_vmx_write_cr4:
	mov eax, [esp+4]
	mov cr4, eax
	ret

;; READ/WRITE EFLAGS REGISTER

global _vmx_read_eflags
_vmx_read_eflags:
	pushfd
	pop eax
	ret

global _vmx_write_eflags
_vmx_write_eflags:
	mov eax, [esp+4]
	push eax
	popfd
	ret

;; READ/WRITE MSR

global _vmx_read_msr
_vmx_read_msr:
	pushad
	mov ecx, [esp+36]
	rdmsr
	mov ecx, [esp+40]
	mov dword [ecx], eax
	add ecx, 4
	mov dword [ecx], edx
	popad
	ret

global _vmx_write_msr
_vmx_write_msr:
	pushad
	mov ecx, [esp+36]
	mov ebx, [esp+40]
	mov dword eax, [ebx]
	add ebx, 4
	mov dword edx, [ebx]
	wrmsr
	popad
	ret

;; VMXON

extern _vmxon_ptr
global _vmx_vmxon
_vmx_vmxon:
	vmxon [_vmxon_ptr]
	jbe vmxon_failed
	vmxon_pass:
		mov eax, 1
		jmp vmxon_done
	vmxon_failed:
		mov eax, 0
	vmxon_done:
	ret

;; VMXOFF

global _vmx_vmxoff
_vmx_vmxoff:
	vmxoff
	ret

;; VMPTRLD

extern _vmcs_ptr

global _vmx_vmptrld
_vmx_vmptrld:
	vmptrld [_vmcs_ptr]
	jbe vmptrld_failed
	vmptrld_pass:
		mov eax, 1
		jmp vmptrld_done
	vmptrld_failed:
		mov eax, 0
	vmptrld_done:
	ret

;; VMPTRLD

global _vmx_vmclear
_vmx_vmclear:
	vmclear [_vmcs_ptr]
	jbe vmclear_failed
	vmclear_pass:
		mov eax, 1
		jmp vmclear_done
	vmclear_failed:
		mov eax, 0
	vmclear_done:
	ret

; VMREAD/VMWRITE

; void vmv_vmwrite(unsigned int field, unsigned int value)
global _vmx_vmwrite
_vmx_vmwrite:
	mov eax, [esp+4]
	vmwrite eax, [esp+8]
	ret

; unsigned int vmv_vmread(unsigned int field)
global _vmx_vmread
_vmx_vmread:
	mov eax, [esp+4]
	vmread eax, eax
	ret

;; VMLAUNCH

global _vmx_vmlaunch
_vmx_vmlaunch:
	vmlaunch
	jbe vmlaunch_failed
	vmlaunch_pass:
		mov eax, 1
		jmp vmlaunch_done
	vmlaunch_failed:
		mov eax, 0
	vmlaunch_done:
	ret

;; VMRESUME

global _vmx_vmresume
_vmx_vmresume:
	vmresume
	jbe vmresume_failed
	vmresume_pass:
		mov eax, 1
		jmp vmresume_done
	vmresume_failed:
		mov eax, 0
	vmresume_done:
	ret

;; SGDT

extern _gdtr
global _sgdt
_sgdt:
	sgdt [_gdtr]
	ret

;; SIDT

extern _idtr
global _sidt
_sidt:
	sidt [_idtr]
	ret
