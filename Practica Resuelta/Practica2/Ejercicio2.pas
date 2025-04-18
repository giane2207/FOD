{El encargado de ventas de un negocio de productos de limpieza desea
administrar el stock de los productos que vende. Para ello, 
genera un archivo maestro donde figuran todos los productos que comercializa.
De cada producto se maneja la siguiente información: código de producto, 
nombre comercial, precio de venta, stock actual y stock mínimo. 
Diariamente se genera un archivo detalle donde se registran todas las ventas de
productos realizadas. De cada venta se registran: código de producto y 
cantidad de unidades vendidas. Se pide realizar un programa con opciones para:

a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
    ● Ambos archivos están ordenados por código de producto.
    ● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del archivo detalle.
    ● El archivo detalle sólo contiene registros que están en el archivo maestro.

b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo stock actual esté por debajo del stock mínimo permitido.}

program Ejercicio2;
const
    valorAlto = '9999';
type    
    producto = record
        cod: String[4];
        nombre: String[4];
        precio: real;
        stock: integer;
        stockMinimo: integer;
    end;

    venta = record 
        cod: String[4];
        cant: integer;
    end;

    maestro = file of producto;
    detalle = file of venta;

    procedure leer (var archivo: detalle; var v: venta);
    begin
         if not(EOF(archivo)) then
             read(archivo, v)
        else 
            v.cod := valorAlto;    
    end;

    procedure actualizarMaestro (var mae: maestro; var det: detalle);
    var
        p: producto;
        v, v_actual: venta;
    begin
      reset(mae);
      reset(det);

      read(mae, p);
      leer(det, v);

      while (v.cod <> valorAlto) do begin
        v_actual := v;
        v_actual.cant := 0;
        
        {Totalizo la cantidad vendida de producto iguales 
        en archivo detalle}
        while (v_actual.cod = v.cod) do begin
            v_actual.cant := v_actual.cant + v.cant;
            leer(det,v);
        end;

        {busco el producto con el codigo en el maestro}
        while(p.cod <> v_actual.cod) do
            read(mae, p);
        
        {actualizo el maestro}
        p.stock := p.stock - v_actual.cant;
        seek(mae, FilePos(mae)-1);
        write(mae, p);
        
        if not(EOF(mae)) then
            read(mae, p);
      end;
      close(det);
      close(mae);
    end;

    procedure listarStockMinimo(var mae: maestro);
    var
        p: producto;
        txt: Text;
    begin
      assign(txt, 'stock_minimo.txt');
      rewrite(txt);
      reset(mae);

      while not(EOF(mae)) do begin
        read(mae, p);

        if (p.stock < p.stockMinimo) then
          writeln(txt, p.cod, ' ', p.nombre, ' ', p.precio:2:1, ' ', p.stock, ' ', p.stockMinimo);
      end;

      close(mae);
      close(txt);
    end;

var
    mae: maestro;
    det: detalle;
    opcion:Byte;
begin
    assign(mae, 'Archivo_maestro');
    assign(det, 'Archivo_detalle');
    
    repeat
        writeln('Opciones disponibles:');
        writeln('1. Actualizar el archivo maestro');
        writeln('2. Listar productos con menor stock del permitido');
        writeln('3. Salir');
        writeln('Ingrese una opcion: ');
        readln(opcion);

        case opcion of
            1: actualizarMaestro(mae,det);
            2: listarStockMinimo(mae);
        end;
    until opcion = 3;

end.