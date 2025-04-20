{Una empresa posee un archivo con información de los ingresos percibidos 
por diferentes empleados en concepto de comisión, de cada uno de ellos se conoce: 
código de empleado, nombre y monto de la comisión. La información del archivo se 
encuentra ordenada por código de empleado y cada empleado puede aparecer más de una vez en el archivo de comisiones.
Realice un procedimiento que reciba el archivo anteriormente descrito y lo compacte. 
En consecuencia, deberá generar un nuevo archivo en el cual, 
cada empleado aparezca una única vez con el valor total de sus comisiones.

NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser recorrido una única vez.}

program ejercicio1;
const  
    valorAlto = '9999';
type
    comision = record
        cod: String[5];
        nombre: String[10];
        monto: real;
    end;

    archivo_detalle = file of comision;

    procedure leer (var archivo: archivo_detalle; var c: comision);
    begin
         if not(EOF(archivo)) then
             read(archivo, c)
        else 
            c.cod := valorAlto;    
    end;

    procedure mostrar (var archivo: archivo_detalle);
    var 
        c: comision;
    begin
        reset(archivo);

        writeln('Contenido del archivo:');
        writeln('----------------------------');
        while not eof(archivo) do begin
            read(archivo, c);
            writeln('Codigo: ', c.cod, ' | Nombre: ', c.nombre, ' | Monto: ', c.monto:0:2);
         end;

         close(archivo);
    end;

var
    merge, det: archivo_detalle;
    nombre: String[5];
    comi, comi_actual: comision;
begin
    write('Ingrese el nombre del archivo: ');
    readln(nombre);
    assign(merge, nombre);
    rewrite(merge);
    
    Assign(det, 'archivo_detalle');
    reset(det);

    leer(det, comi);
    while (comi.cod <> valorAlto) do begin
        comi_actual := comi; 
        comi_actual.monto := 0;

        while(comi_actual.cod = comi.cod) do begin
            comi_actual.monto := comi_actual.monto + comi.monto;
            leer(det, comi);
      end;

      write(merge, comi_actual);
    end;
    close(det);
    close(merge);
    
    mostrar(det);
    mostrar(merge);
end.