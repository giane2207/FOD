program crea_detalle;

type
    comision = record
        cod: String[5];
        nombre: String[10];
        monto: real;
    end;

    archivo_detalle = file of comision;

var
    archivo: archivo_detalle;
    c: comision;

begin
    assign(archivo, 'archivo_detalle');
    rewrite(archivo);

    // Empleado 1 - 2 registros
    c.cod := '00001';
    c.nombre := 'Juan';
    c.monto := 100.5;
    write(archivo, c);

    c.cod := '00001';
    c.nombre := 'Juan';
    c.monto := 200.0;
    write(archivo, c);

    // Empleado 2 - 3 registros
    c.cod := '00002';
    c.nombre := 'Ana';
    c.monto := 300.0;
    write(archivo, c);

    c.cod := '00002';
    c.nombre := 'Ana';
    c.monto := 50.0;
    write(archivo, c);

    c.cod := '00002';
    c.nombre := 'Ana';
    c.monto := 70.0;
    write(archivo, c);

    // Empleado 3 - 1 registro
    c.cod := '00003';
    c.nombre := 'Luis';
    c.monto := 120.0;
    write(archivo, c);

    close(archivo);

    writeln('Archivo "archivo_detalle" creado con exito.');
end.