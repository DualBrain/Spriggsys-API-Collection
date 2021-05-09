#include<strsafe.h>
int32 FUNC_MYTHREADFUNCTION(ptrszint*_FUNC_MYTHREADFUNCTION_OFFSET_LPPARAM);
extern "C"{
	__declspec(dllexport) int32 MyThreadFunction(ptrszint*lpParam){
		return FUNC_MYTHREADFUNCTION((lpParam));
	}
}

int32 sizeoftchar(){
	return sizeof(TCHAR);
}