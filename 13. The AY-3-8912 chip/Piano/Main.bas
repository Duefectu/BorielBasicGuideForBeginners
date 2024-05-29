' - Piano -------------------------------------------------
' https://tinyurl.com/yh24726f

Main()
STOP


' - Includes ----------------------------------------------
' Librerías de Boriel
#INCLUDE <keys.bas>
' Recursos
#INCLUDE "Piano.fnt.bas"
#INCLUDE "Ondas.udg.bas"


' - Defines -----------------------------------------------
' Puertos del chip AY-3-8912
#DEFINE AY_CONTROL 65533
#DEFINE AY_DATA 49149
' Registros del chip AY-3-8912
#DEFINE AY_A_FINEPITCH 0
#DEFINE AY_A_COURSEPITCH 1
#DEFINE AY_B_FINEPITCH 2
#DEFINE AY_B_COURSEPITCH 3
#DEFINE AY_C_FINEPITCH 4
#DEFINE AY_C_COURSEPITCH 5
#DEFINE AY_NOISEPITCH 6
#DEFINE AY_MIXER 7
#DEFINE AY_A_VOLUME 8
#DEFINE AY_B_VOLUME 9
#DEFINE AY_C_VOLUME 10
#DEFINE AY_ENVELOPE_FINE 11
#DEFINE AY_ENVELOPE_COURSE 12
#DEFINE AY_ENVELOPE_SHAPE 13
#DEFINE AY_PORT_A 14
#DEFINE AY_PORT_B 15


' - Variables ---------------------------------------------
' Frecuencias de las notas musicales
dim Music_Notas(59,1) as UByte => { _
_                       ' Nota Frec Id
    { $06, $af }, _     ' C2   1711 0
    { $06, $4e }, _     ' C#2  1614 1
    { $05, $f4 }, _     ' D2   1524 2
    { $05, $9e }, _     ' D#2  1438 3
    { $05, $4e }, _     ' E2   1358 4
    { $05, $01 }, _     ' F2   1281 5
    { $04, $ba }, _     ' F#2  1210 6
    { $04, $76 }, _     ' G2   1142 7
    { $04, $36 }, _     ' G#2  1078 8
    { $03, $f9 }, _     ' A2   1017 9
    { $03, $c0 }, _     ' A#2  960  10
    { $03, $8a }, _     ' B2   906  11
_
    { $03, $57 }, _     ' C3   855  12
    { $03, $27 }, _     ' C#3  807  13
    { $02, $fa }, _     ' D3   762  14
    { $02, $cf }, _     ' D#3  719  15
    { $02, $a7 }, _     ' E3   679  16
    { $02, $81 }, _     ' F3   641  17
    { $02, $5d }, _     ' F#3  605  18
    { $02, $3b }, _     ' G3   571  19
    { $02, $1b }, _     ' G#3  539  20
    { $01, $fd }, _     ' A3   509  21
    { $01, $e0 }, _     ' A#3  480  22
    { $01, $c5 }, _     ' B3   453  23
_
    { $01, $ac }, _     ' C4   428  24
    { $01, $94 }, _     ' C#4  404  25
    { $01, $7d }, _     ' D4   381  26
    { $01, $68 }, _     ' D#4  360  27
    { $01, $53 }, _     ' E4   339  28
    { $01, $40 }, _     ' F4   320  29
    { $01, $2e }, _     ' F#4  302  30
    { $01, $1d }, _     ' G4   285  31
    { $01, $0d }, _     ' G#4  269  32
    { $00, $fe }, _     ' A4   254  33
    { $00, $f0 }, _     ' A#4  240  34
    { $00, $e3 }, _     ' B4   227  35
_
    { $00, $d6 }, _     ' C5   214  36
    { $00, $ca }, _     ' C#5  202  37
    { $00, $be }, _     ' D5   190  38
    { $00, $b4 }, _     ' D#5  180  39
    { $00, $aa }, _     ' E5   170  40
    { $00, $a0 }, _     ' F5   160  41
    { $00, $97 }, _     ' F#5  151  42
    { $00, $8f }, _     ' G5   143  43
    { $00, $87 }, _     ' G#5  135  44
    { $00, $7f }, _     ' A5   127  45
    { $00, $78 }, _     ' A#5  120  46
    { $00, $71 }, _     ' B5   113  47  
_
    { $00, $6b }, _     ' C6   107  48
    { $00, $65 }, _     ' C#6  101  49
    { $00, $5f }, _     ' D6   95   50
    { $00, $5a }, _     ' D#6  90   51
    { $00, $55 }, _     ' E6   85   52
    { $00, $50 }, _     ' F6   80   53
    { $00, $4c }, _     ' F#6  76   54
    { $00, $47 }, _     ' G6   71   55
    { $00, $43 }, _     ' G#6  67   56
    { $00, $40 }, _     ' A6   64   57
    { $00, $3c }, _     ' A#6  60   58
    { $00, $39 } _      ' B6   57   59  
}
' Teclas del teclado del piano
DIM Teclas(23) AS UInteger => { _
    KEYZ, KEYS, KEYX, KEYD, KEYC, KEYV, _
    KEYG, KEYB, KEYH, KEYN, KEYJ, KEYM, _
    KEYQ, KEY2, KEYW, KEY3, KEYE, KEYR, _
    KEY5, KEYT, KEY6, KEYY, KEY7, KEYU _
}
' Nombres de las notas
DIM Notacion(12) AS String
' Dibujo del tipo de onda del chip AY-3-8912
DIM TiposOndas(8) AS String
' Identificador del tipo de onda en el chip AY-3-8912
DIM IdsOndas(8) AS UByte => { 255,0,4,8,10,11,12,13,14 }
' Nota y octava actuales y número de teclas pulsadas
DIM nota, octava, numNotas AS UByte
' Volumen, copia del mismo, forma de onda e instrumento
DIM volumen, volumen2, onda, tipo AS UByte
' Corta los rebotes de las pulsaciones de teclas
DIM rOctava, rVolumen, rOnda, rFrecuencia, rTipo AS UByte
' Se ha modificado el volumen
DIM mVolumen AS UByte
' Se pueden tocar hasta tres notas al mismo tiempo
DIM notas(2) AS UByte
' Frecuencia de oscilación de la forma de onda
DIM frecuencia AS UInteger


' - Módulos adicionales -----------------------------------
#INCLUDE "ControlTeclado.bas"


' - Subrutina principal -----------------------------------
SUB Main()
    ' Variables temporales
    DIM n, m, o, f1, f2, fo1, fo2, canal AS UByte
    
    ' Inicializamos el sistema
    Inicializar()
        
    ' Inicializamos el mezclador
    AYReg(AY_MIXER,%00111000)
    ' Ajustamos los volumenes de los canales
    AYReg(AY_A_VOLUME,15)   ' Volumen al máximo
    AYReg(AY_B_VOLUME,15)   ' Volumen al máximo
    AYReg(AY_C_VOLUME,15)   ' Volumen al máximo
    
    ' Octava inicial menos 2
    octava = 0
    ' Volumen inicial
    volumen = 15
    ' Copia del volumen
    volumen2 = 15
    ' Forma de onda plana
    onda = 0
    ' Frecuencia por defecto
    frecuencia = 10
    
    ' Bucle infinito
    DO
        ' Partimos de 0 teclas/notas
        numNotas = 0
        ' Escaneamos todas las teclas posibles
        FOR n = 0 TO 23
            ' Se ha pulsado la tecla...
            IF Multikeys(Teclas(n)) <> 0 THEN
                ' Añadimos la nota a "notas"
                notas(numNotas) = (octava * 12) + n
                ' Si ya tenemos tres notas...
                IF numNotas = 3 THEN
                    ' No queremos más notas
                    EXIT FOR
                ' Si no tenemos tres notas...
                ELSE
                    ' Incrementamos el contador de notas
                    numNotas = numNotas + 1
                END IF
            END IF
        NEXT n
        
        ' Controlamos las opciones superiores (octava, 
        ' volumen, forma de onda, etc...
        ControlTeclado() 
        
        ' Si hay definida una forma de onda...
        IF onda <> 0 THEN
            ' Si el volumen no es 16...
            IF volumen <> 16 THEN
                ' Saca una copia del volumen actual
                volumen2 = volumen
                ' Pon el volumen a 16
                volumen = 16
                ' Marca de volumen modificado
                mVolumen = 1
            END IF
        END IF

        ' Actualizamos la información en pantalla
        ' Octava actual
        PRINT AT 2,16;(octava + 2);
        ' Si no hay forma de onda seleccionada...
        IF onda = 0 THEN
            ' Se muestra el volumen
            PRINT AT 3,16;volumen;" ";
            ' No se muestra la frecuencia de la onda
            PRINT AT 5,16;"-    ";
        ' Si hay una forma de onda seleccionada...
        ELSE
            ' No se muestra el volumen
            PRINT AT 3,16;"- ";
            ' Se muestra la frecuencia de la onda
            PRINT AT 5,16;frecuencia;" ";
        END IF
        
        ' Mostramos el tipo de onda seleccionada
        PRINT AT 4,16;TiposOndas(onda);

        ' Imprimimos el tipo de intrumento usado 
        IF tipo = 0 THEN
            PRINT AT 6,16;"Tono ";
        ELSEIF tipo = 1 THEN
            PRINT AT 6,16;"Ruido";
        ELSE
            PRINT AT 6,16;"T + R";
        END IF

        ' Se ha modificado el volumen o hay una forma de onda
        IF mVolumen <> 0 OR onda <> 0 THEN
            ' Ajustamos el volumen
            AYReg(AY_A_VOLUME,volumen)
            AYReg(AY_B_VOLUME,volumen)
            AYReg(AY_C_VOLUME,volumen)
            ' Reseteamos el flag de volumen modificado
            mVolumen = 0
            ' Ajustamos el mezclador de volumen
            IF tipo = 0 THEN
                ' Solo tono
                AYReg(AY_MIXER,%00111000)
            ELSEIF tipo = 1 THEN
                ' Solo ruido
                AYReg(AY_MIXER,%00000111)
            ELSE
                ' Tono + ruido
                AYReg(AY_MIXER,%00111111)
            END IF
        END IF
        
        ' Reproducimos las notas --------------------------
        ' Tres notas como máximo
        FOR n = 1 TO 3
            ' El canal es igual a contador n - 1
            canal = n - 1           
            ' Si ya hemos reproducido todas las notas...
            IF n>numNotas THEN
                ' Imprimimos un "-" en la info del canal
                PRINT AT n+7,16;"-  ";
                ' Silenciamos el canal con una nota 0
                AYReg(AY_A_COURSEPITCH+(canal*2),0)
                AYReg(AY_A_FINEPITCH+(canal*2),0) 
            ' Si aún quedan notas para reproducir...
            ELSE
                ' Nota actual
                nota = notas(canal)
                ' Obtenemos la frecuencia de la nota
                f1 = Music_Notas(nota,0)
                f2 = Music_Notas(nota,1)
                ' Calculamos la octava de la nota
                o = INT(nota/12)+2
                ' Imprimimos la nota y la octava
                PRINT AT n+7,16;Notacion(nota MOD 12);o;" "; 

                ' Hacemos sonar la nota
                AYReg(AY_A_COURSEPITCH+(canal*2),f1)
                AYReg(AY_A_FINEPITCH+(canal*2),f2)   
                
                ' Si el volumen es 16, usamos onda...
                IF volumen = 16 THEN
                    ' Programamos la forma de la onda
                    AYReg(AY_ENVELOPE_SHAPE,IdsOndas(onda))
                    ' Byte alto de la frecuencia
                    fo1= frecuencia >> 8
                    ' Byte bajo de la frecuencua
                    fo2= frecuencia bAND $00ff
                    ' Programamos la frecuencia de la onda
                    AYReg(AY_ENVELOPE_COURSE,fo1)
                    AYReg(AY_ENVELOPE_FINE,fo2)
                END IF
            END IF
        NEXT n        
    LOOP
END SUB


' - Inicializa el sistema ---------------------------------
SUB Inicializar()
    ' Texto de cada una de las notas
    Notacion(0)="C"
    Notacion(1)="C#"
    Notacion(2)="D"
    Notacion(3)="D#"
    Notacion(4)="E"
    Notacion(5)="F"
    Notacion(6)="F#"
    Notacion(7)="G"
    Notacion(8)="G#"
    Notacion(9)="A"
    Notacion(10)="A#"
    Notacion(11)="B"
    
    ' Ajustamos los GDUs para que apunten a Ondas
    POKE (uinteger 23675, @Ondas)
    
    ' Definimos los tipos de onda del chip AY
    TiposOndas(0)="\G\G\G\G"
    TiposOndas(1)="\A\B\B\B"
    TiposOndas(2)="\D\B\B\B"
    TiposOndas(3)="\E\E\E\E"
    TiposOndas(4)="\A\F\A\F"
    TiposOndas(5)="\E\C\C\C"
    TiposOndas(6)="\D\D\D\D"
    TiposOndas(7)="\F\C\C\C"
    TiposOndas(8)="\F\A\F\A"
    
    ' Dibujamos el teclado del piano
    DibujarTeclado()    
    
    ' Dibujamos el texto fijo de los indicadores
    PRINT AT 0,15;INK 1;"PIANO";
    PRINT AT 2,0;"       Octava :          (0-9)";
    PRINT AT 3,0;"      Volumen :          (O-P)";
    PRINT AT 4,0;"         Onda :          (K-L)";
    PRINT AT 5,0;"   Frecuencia :       (O-P-CS)";
    PRINT AT 6,0;"  Instrumento :            (1)";
    PRINT AT 8,0;"      Canal A :";
    PRINT AT 9,0;"      Canal B :";
    PRINT AT 10,0;"      Canal C :";
END SUB


SUB DibujarTeclado()
    ' Usamos la fuente piano
    POKE (uinteger 23606, @Piano-256)
    ' Imprimimos las teclas del piano (ver Piano.fnt)
    PRINT AT 13,1;"af$l$kaf$l$l$kaf$l$kaf$l$l$ka";
    PRINT AT 14,1;"amnopkaqrstuvkamnopkaqrstuvka";
    PRINT AT 15,1;"afSlDkafGlHlJkaf2l3kaf5l6l7ka";
    PRINT AT 16,1;"aghihjaghihihjaghihjaghihihja";
    PRINT AT 17,1;"a a a a a a a a a a a a a a a";
    PRINT AT 18,1;"awaxayaza{a|a}awaxayaza{a|a}a";
    PRINT AT 19,1;"aZaXaCaVaBaNaMaQaWaEaRaTaYaUa";
    PRINT AT 20,1;"bcdcdcdcdcdcdcdcdcdcdcdcdcdce";
    ' Restauramos la fuente por defecto
    POKE (uinteger 23606, $3c00)
END SUB


' - Envia un valor al registro AY indicado ----------------
' Parámetros:
'   registro (UByte): Registro a modificar
'   valor (UByte): Valor a guardar en el registro
SUB AYReg(registro AS UByte, valor AS UBYTE)
    OUT AY_CONTROL,registro
    OUT AY_DATA,valor
END SUB
