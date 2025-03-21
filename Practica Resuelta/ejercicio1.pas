program ejercicio1;
type    
     archivo_numeros = file of Integer;
var
     numeros : archivo_numeros;
     nombre_fisico : string[20];
     num: Integer;
begin
     write('Ingrese el nombre del archivo: ');
     readln(nombre_fisico);
     assign(numeros, nombre_fisico);
     rewrite(numeros);
     write('Ingrese un numero: ');
     readln(num);
    while (num <> 30000) do begin
         write(numeros, num);
         write('Ingrese un numero: ');
         readln(num);
    end;
    close(numeros);
end.
