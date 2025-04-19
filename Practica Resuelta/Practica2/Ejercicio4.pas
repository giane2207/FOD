
{4. Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados. 
De cada producto se almacena: código del producto, nombre, descripción, stock disponible, stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. 
Se debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo maestro. 
La información que se recibe en los detalles es: código de producto y cantidad vendida. 
Además, se deberá informar en un archivo de texto: nombre de producto, descripción, stock disponible y 
precio de aquellos productos que tengan stock disponible por debajo del stock mínimo. Pensar alternativas 
sobre realizar el informe en el mismo procedimiento de actualización, o realizarlo en un procedimiento separado 
(analizar ventajas/desventajas en cada caso).

Nota: todos los archivos se encuentran ordenados por código de productos. 
En cada detalle puede venir 0 o N registros de un determinado producto.}

program Ejercicio4;
Uses SysUtils;
const
    valorAlto = '9999';
    cantArchivos = 30;
type
    producto = record   
        cod: String[4];
        nombre, descripcion: String[8];
        stock, stockMin: integer;
        precio: real;
    end;

    venta = record
        cod: String[4];
        cant: integer;
    end;

    maestro = file of producto;
    detalle = file of venta;
    arch_detalle = array [1..cantArchivos] of detalle;
    reg_detalle = array [1..cantArchivos] of venta;
    

    procedure leer (var archivo: detalle; var dato: venta);
    begin
         if not(EOF(archivo)) then
             read(archivo, dato)
        else 
            dato.cod := valorAlto;    
    end;

    procedure minimo (var detalles: arch_detalle; var regd: reg_detalle; var min: venta);
    var 
        i, posMin: integer;
    begin
      posMin := 1;
      for i := 1 to cantArchivos do begin
        if (regd[i].cod <= regd[posMin].cod) then
            min := regd[i];
            posMin := i;
      end;

     
      leer(detalles[posMin], regd[posMin]);
    end;
    procedure actualizarMaestro(var mae: maestro; var det: arch_detalle; var regd: reg_detalle);
    var 
        i: integer;
        regm: producto;
        aux, min: venta;
    begin
        {Abro los detalles y leo sus registros}
        for i:= 1 to cantArchivos do begin
            reset(det[i]);
            leer(det[i], regd[i]);
        end;

        reset(mae);
        read(mae, regm);
        minimo(det, regd, min);

        while (min.cod <> valorAlto) do begin
           aux.cod := min.cod;
           aux.cant := 0;

           while (aux.cod = min.cod) do begin
              aux.cant := aux.cant + min.cant;
              minimo(det, regd, min);
           end;

           while (aux.cod <> regm.cod) do
             read(mae, regm);
            
            regm.stock := regm.stock - aux.cant;
            seek(mae, FilePos(mae) - 1);
            write(mae, regm);

            if not (EOF(mae)) then
                read(mae, regm);
        end;

        close(mae);
        for i:= 1 to cantArchivos do 
            close(det[i]);
    end;

    procedure realizarInforme(var mae: maestro);
    var
        txt: Text;
        p: producto;
    begin
      assign(txt, 'archivo_informe');
      rewrite(txt);

      reset(mae);
      writeln(txt, 'nombre | descripcion | stock | precio ');
      while not (eof(mae)) do begin
        read(mae, p);
        if (p.stock < p.stockMin) then
          writeln(txt, p.nombre, ' | ', p.descripcion, ' | ', p.stock, ' | ', p.precio:2:1);
      end;
      close(mae);
      close(txt);
    end;

var
    mae: maestro;
    detalles: arch_detalle;
    regd: reg_detalle;
    nro_detalle: String;
    i: integer;
begin
    assign(mae, 'archivo_maestro');
    for i := 1 to cantArchivos do begin
        nro_detalle := IntToStr(i);
        assign(detalles[i], 'det' + nro_detalle);
    end;
    actualizarMaestro(mae,detalles, regd);  
    realizarInforme(mae);
end.