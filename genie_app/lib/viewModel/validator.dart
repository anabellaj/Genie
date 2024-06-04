class Validator{
  RegExp get _emailRegex => RegExp(r'^\S+@\S+$');


   String? validateEmpty(String? value){
    if(value==null || value.isEmpty){
      return 'Campo Obligatorio';
    }
    return null;
   
  }

   String? validateEmail(String? value){
    if(value==null || value.isEmpty){
      return 'Campo obligatorio';
    }else if(!_emailRegex.hasMatch(value)){
      return 'Ingrese un correo válido';
    }
    return null;
  }

  bool validateEmptyMessage(String message){
    return message.isNotEmpty;
  }

}