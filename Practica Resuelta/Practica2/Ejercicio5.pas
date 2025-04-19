{5. Suponga que trabaja en una oficina donde está montada una LAN (red local). 
La misma fue construida sobre una topología de red que conecta 5 máquinas entre sí y todas las máquinas se conectan 
con un servidor central. Semanalmente cada máquina genera un archivo de logs informando las sesiones abiertas por 
cada usuario en cada terminal y por cuánto tiempo estuvo abierta. Cada archivo detalle contiene 
los siguientes campos: cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba 
los archivos detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha, tiempo_total_de_sesiones_abiertas.

Notas:
    ● Cada archivo detalle está ordenado por cod_usuario y fecha.
    ● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o inclusive, en diferentes máquinas.
    ● El archivo maestro debe crearse en la siguiente ubicación física: /var/log.}

program Ejercicio5;
const
    valorAlto = '9999';
    cantArchivos = 5;
type
    sesion = record    
        cod: String[4];
        fecha: String[8];
        tiempo: integer;
    end;

    maestro = file of sesion;
    detalle = file of sesion;

    arch_detalle = array [1..cantArchivos] of detalle;
    reg_detalle = array [1..cantArchivos] of sesion;
    
    procedure leer (var archivo: detalle; var dato: sesion);
    begin
         if not(EOF(archivo)) then
             read(archivo, dato)
        else 
            dato.cod := valorAlto;    
    end;

    procedure minimo(var detalles: arch_detalle; var regd: reg_detalle; var min: sesion);
    var
        i, posMin: integer;
    begin
        posMin := -1;
        min.cod := valorAlto; // Inicializo el minimo como muy grande
        for i := 1 to cantArchivos do begin

            // Comparo si el registro actual es menor al minimo
            if (regd[i].cod < min.cod) or ((regd[i].cod = min.cod) and (regd[i].fecha < min.fecha)) then begin
                 min := regd[i];    
                 posMin := i;      
                end;
        end;

        if (min.cod <> valorAlto) then
            leer(detalles[posMin], regd[posMin]);
    end;

    procedure crearMaestro (var mae: maestro; var detalles: arch_detalle; var sesiones: reg_detalle);
    var
        i, totalTiempo: integer;
        min, actual: sesion;
    begin

      for i := 1 to cantArchivos do begin
        reset(detalles[i]);
        leer(detalles[i], sesiones[i]);
      end;

      rewrite(mae);

      minimo(detalles, sesiones, min);
      while (min.cod <> valorAlto) do begin
        actual.cod := min.cod;
        
        while (min.cod = actual.cod) do begin
          actual.fecha := min.fecha;
          totalTiempo := 0;

          while (min.cod = actual.cod) and (min.fecha = actual.fecha) do begin
            totalTiempo := totalTiempo + min.tiempo;
            minimo(detalles, sesiones, min);
          end;

          actual.tiempo := totalTiempo;
          write(mae, actual);
        end;
      end;

     close(mae);
     for i:= 1 to cantArchivos do 
         close(detalles[i]);
    end;

var
    mae: maestro;
    detalles: arch_detalle;
    sesiones: reg_detalle;
    i: integer;
    nro_detalle: String;
begin
    assign(mae, '/var/log/servidor');

    for i := 1 to cantArchivos do begin
        nro_detalle := IntToStr(i);
        assign(detalles[i], 'det' + nro_detalle);
    end;
    crearMaestro(mae, detalles, sesiones);
end.