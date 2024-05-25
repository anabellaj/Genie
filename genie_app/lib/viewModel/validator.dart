class Validator{
  

  String? validateEmpty(String? value){
    if(value==null || value.isEmpty){
      return 'Campo Obligatorio';
    }
    return null;
   
  }

}