program ejercicio2;
type    
     archivo_numeros = file of Integer;
var
     numeros : archivo_numeros;
     nombre_fisico : string[20];
     num, cantMenores, suma: Integer;
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
     reset(numeros);
     cantMenores:= 0;
     suma:= 0;
     while (not eof(numeros)) do begin
         read(numeros, num);
         writeln('Numero: ' , num);
         suma += num;
         if (num < 1500) then
            cantMenores += 1;
    end;
    writeln('La cantidad de numeros menores a 1500 es: ' , cantMenores);
    writeln('El promedio de los numeros ingresados es: ' , suma/FileSize(numeros):1:1);
    close(numeros);
end.