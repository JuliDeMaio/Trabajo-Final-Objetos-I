!classDefinition: #MiniMiUNQTest category: 'tpFinalGrupo3'!
TestCase subclass: #MiniMiUNQTest
	instanceVariableNames: 'miniMiUNQ factory unUsuarioRoot unUsuarioPublico unUsuarioAdministrador unUsuarioComun otroUsuarioRoot otroUsuarioAdministrador directorioRaiz unArchivoRecienCreado unDirectorioRecienCreado'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'tpFinalGrupo3'!

!MiniMiUNQTest methodsFor: 'factory' stamp: 'jdm 12/5/2022 22:38:46'!
fechaDelDiaDeHoy

	^ FixedGregorianDate today! !

!MiniMiUNQTest methodsFor: 'factory' stamp: 'jdm 12/5/2022 19:56:40'!
setUp
	
	unUsuarioRoot _ UsuarioRoot conNombreDeUsuario: 'root' conContraseña: 'root'.
	unUsuarioPublico _ UsuarioPublico conNombreDeUsuario: 'publico' conContraseña: 'publico'.
	unUsuarioAdministrador _ UsuarioAdministrador conNombreDeUsuario: 'admin' conContraseña: 'admin'.
	unUsuarioComun _ UsuarioComun conNombreDeUsuario: 'comun' conContraseña: 'comun'.
	otroUsuarioRoot _ UsuarioRoot conNombreDeUsuario: 'root2' conContraseña: 'root2'.
	otroUsuarioAdministrador _ UsuarioAdministrador conNombreDeUsuario: 'admin2' conContraseña: 'admin2'.
	
	directorioRaiz _ Directorio conNombre: 'raiz' conDueño: unUsuarioRoot conFecha: November/22/2000.
	unDirectorioRecienCreado _ Directorio conNombre: 'fotos' conDueño: unUsuarioRoot conFecha: December/18/2000.
	unArchivoRecienCreado _ Archivo conNombre: 'notas' conDueño: unUsuarioRoot conFecha: November/23/2000.
	
	miniMiUNQ _ MiniMiUNQ conUsuarioRoot: unUsuarioRoot conUsuarioPublico: unUsuarioPublico conUsuarioActual: unUsuarioPublico conDirectorioRaiz: directorioRaiz.
	! !


!MiniMiUNQTest methodsFor: 'streams-tests' stamp: 'jdm 12/8/2022 01:06:10'!
test01_sePuedeAlmacenarEnElDiscoDuroLaInformacionDelDirectorioActual

	| unStream archivoGenerado |
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearDirectorioConNombre: 'recetas'.
	miniMiUNQ accederADirectorio: 'recetas'.
	miniMiUNQ crearArchivoConNombre: 'receta1'.
	miniMiUNQ compartirElemento: 'receta1' conUsuario: unUsuarioPublico.
	miniMiUNQ escribir: 'Esta receta es de fideos con tuco' en: 'receta1'.
	miniMiUNQ crearArchivoConNombre: 'receta2'.
	miniMiUNQ compartirElemento: 'receta2' conUsuario: unUsuarioPublico.
	miniMiUNQ compartirElemento: 'receta2' conUsuario: unUsuarioComun.
	miniMiUNQ escribir: 'Esta receta es de fideos con pesto' en: 'receta2'.
	miniMiUNQ crearArchivoConNombre: 'receta3'.
	miniMiUNQ escribir: 'Esta receta es de bondiola a la bbq' en: 'receta3'.
	
	miniMiUNQ guardarResultadoEnDiscoDuro.
    	archivoGenerado:= 'recetas.txt' asFileEntry.

	unStream:= ReadWriteStream with: ''.
	unStream nextPutAll: 'Usuario:root' , String newLineString; nextPutAll: 'raiz/recetas/:3' ;tab; nextPutAll: 'elementos' , 
						String newLineString; tab; nextPutAll: 'receta1' ; tab; nextPutAll: FixedGregorianDate today asString; tab ; nextPutAll: 'publico/' , 
						String newLineString; tab; nextPutAll: 'receta2' ; tab; nextPutAll: FixedGregorianDate today asString; tab ; nextPutAll: 'comun/publico/' , 
						String newLineString; tab; nextPutAll: 'receta3' ; tab; nextPutAll: FixedGregorianDate today asString; tab ; nextPutAll: '' , String newLineString.
						
	Assert that: archivoGenerado textContents isEqualTo: unStream contents.
								    ! !

!MiniMiUNQTest methodsFor: 'streams-tests' stamp: 'jdm 12/8/2022 19:12:48'!
test02_sePuedeRegistrarUsuariosComunesMasivamenteDesdeUnArchivo

	| unArchivo |
	unArchivo _ ArchivoDeMentira new.
	unArchivo forceWriteStreamDo: [: unStream | 
		unStream nextPutAll: 'NombreDeUsuario, Contraseña'.
		unStream newLine.
		unStream nextPutAll: 'francoBeltra, beltra45'.
		unStream newLine.
		unStream nextPutAll: 'juliDema, juli123'.
		].
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuariosComunesUsando: unArchivo.

	Assert that: miniMiUNQ cantidadDeUsuariosRegistrados isEqualTo: 4.
	
								    ! !

!MiniMiUNQTest methodsFor: 'streams-tests' stamp: 'jdm 12/8/2022 18:42:38'!
test03_cuandoNoHayUsuariosEnElArchivoSoloSeImprimeLaCabeceraSinElCuerpo

	| registrador unArchivo |
	unArchivo _ ArchivoDeMentira new.
	registrador _ RegistradorDeUsuarios new.
	
	registrador escribirEn: unArchivo losUsuarios: {}.

	Assert that: unArchivo contenido isEqualTo: 'Usuario, Contraseña'
								    ! !


!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/2/2022 14:35:55'!
test01_cuandoSeInicializaUnSistemaMiniMiUNQElDirectorioActualEsElDirectorioRaiz
	
	Assert that: miniMiUNQ directorioActual isEqualTo: directorioRaiz.! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/2/2022 22:45:48'!
test02_sePuedenCrearDirectoriosEnElDirectorioActual
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearDirectorioConNombre: 'archivos'.
	
	Assert that: miniMiUNQ directorioActual cantidadDeElementos isEqualTo: 1.! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/3/2022 00:31:25'!
test03_cuandoSeQuiereCrearUnDirectorioQueYaExisteEnElDirectorioActual_ElDirectorioLanzaError
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearDirectorioConNombre: 'archivos'.
	
	Assert should: [miniMiUNQ crearDirectorioConNombre: 'archivos'] 
			signal: Error - MessageNotUnderstood 
			withDescription: 'Ya existe un directorio con ese nombre'.
	
	Assert that: miniMiUNQ directorioActual cantidadDeElementos isEqualTo: 1.! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/3/2022 00:50:38'!
test04_cuandoSeAccedeASubdirectoriosdelDirectorioActual_ElDirectorioActualPasaASerElSubdirectorioAccedido
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearDirectorioConNombre: 'archivos'.
	miniMiUNQ accederADirectorio: 'archivos'.
	
	Assert that: miniMiUNQ directorioActual nombre isEqualTo: 'archivos'.! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/3/2022 01:22:12'!
test05_sePuedenCrearArchivosEnElDirectorioActual
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearArchivoConNombre: 'archivo.txt'.
	
	Assert that: miniMiUNQ directorioActual cantidadDeElementos isEqualTo: 1.! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/3/2022 01:26:17'!
test06_cuandoSeQuiereCrearUnArchivoQueYaExisteEnElDirectorioActual_SeLanzaUnError
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearArchivoConNombre: 'archivo.txt'.
	
	Assert should: [miniMiUNQ crearArchivoConNombre: 'archivo.txt'] 
			signal: Error - MessageNotUnderstood 
			withDescription: 'Ya existe un archivo con ese nombre'.
	
	Assert that: miniMiUNQ directorioActual cantidadDeElementos isEqualTo: 1.! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/3/2022 01:23:47'!
test07_noSePuedeAccederAUnArchivoConElComandoAccederADirectorio
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearArchivoConNombre: 'archivo.txt'.
	
	Assert should: [ miniMiUNQ accederADirectorio: 'archivo.txt'] 
	            signal: Error - MessageNotUnderstood 
	            withDescription:  'No se puede realizar esta acción sobre un archivo'.
	
	Assert that: miniMiUNQ directorioActual nombre  isEqualTo: 'raiz'.! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/3/2022 01:29:30'!
test08_noSePuedeAccederElementoQueNoExisteEnElDirectorioActual
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	
	Assert should: [ miniMiUNQ accederADirectorio: 'archivo.txt'] 
	            signal: Error - MessageNotUnderstood 
	            withDescription:  'No existe el elemento buscado'.
	
	Assert that: miniMiUNQ directorioActual nombre  isEqualTo: 'raiz'.! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/3/2022 01:41:10'!
test09_sePuedeAccederAlDirectorioPadreDelDirectorioActual
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearDirectorioConNombre: 'archivos'.
	miniMiUNQ accederADirectorio: 'archivos'.
	miniMiUNQ volverADirectorioPadre.
	
	Assert that: miniMiUNQ directorioActual nombre  isEqualTo: 'raiz'.! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/3/2022 01:54:06'!
test10_cuandoElDirectorioActualEsElRaizYSeIntentaVolverAlDirectorioPadre_SeLanzaUnError

	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	
	
	Assert should: [miniMiUNQ volverADirectorioPadre]
			 signal: Error - MessageNotUnderstood 
			 withDescription: 'Estas en el directorio raiz'.! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 01:36:08'!
test11_cuandoUnUsuarioIniciaSesionElDirectorioInicialEsElRaiz

	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ crearDirectorioConNombre: 'fotos'.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	
	Assert that: miniMiUNQ directorioActual isEqualTo: directorioRaiz.! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 01:41:44'!
test12_sePuedeBorrarUnElementoDelDirectorioActual

	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearDirectorioConNombre: 'fotos'.
	miniMiUNQ borrarElementoConNombre: 'fotos'.
	
	Assert that: miniMiUNQ directorioActual cantidadDeElementos isEqualTo: 0.! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 13:42:19'!
test13_cuandoSeQuiereBorrarUnElementoQueNoExisteEnElDirectorioActual_ElDirectorioLanzaError
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	
	Assert should: [miniMiUNQ borrarElementoConNombre: 'fotos'.] 
			signal: Error - MessageNotUnderstood 
			withDescription: 'No existe el elemento buscado'.
	
	Assert that: miniMiUNQ directorioActual cantidadDeElementos isEqualTo: 0.! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 02:07:57'!
test14_cuandoSeCreaUnArchivoNuevo_EsteNoTieneContenidoEnTexto
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearArchivoConNombre: 'reseña'.
	
	Assert that: (miniMiUNQ leerTextoDe: 'reseña') isEqualTo: ''.! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 02:18:49'!
test15_sePuedeAgregarContenidoEnTextoSobreUnArchivo
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearArchivoConNombre: 'reseña'.
	miniMiUNQ escribir: 'La Scaloneta esta en un nivel altisimo' en: 'reseña'.
	
	Assert that: (miniMiUNQ leerTextoDe: 'reseña') isEqualTo: 'La Scaloneta esta en un nivel altisimo'.! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 02:28:17'!
test16_cuandoSeQuiereEscribirUnTextoEnUnDirectorio_SeLanzaError
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearDirectorioConNombre: 'fotos'.
	
	Assert should: [miniMiUNQ escribir: 'La Scaloneta esta en un nivel altisimo' en: 'fotos']
			 signal: Error - MessageNotUnderstood 
			withDescription: 'No podes realizar esa accion sobre un directorio'.! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 02:30:25'!
test17_cuandoSeQuiereLeerContenidoDeTextoDeUnDirectorio_SeLanzaError
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearDirectorioConNombre: 'fotos'.
	
	Assert should: [miniMiUNQ leerTextoDe: 'fotos']
			 signal: Error - MessageNotUnderstood 
			withDescription: 'No podes realizar esa accion sobre un directorio'.! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 02:44:58'!
test18_cuandoUnUsuarioCreaUnArchivoEsElDueñoDelMismo
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearArchivoConNombre: 'reseña'.
	
	Assert isTrue: (miniMiUNQ elUsuarioActualEsElDueñoDe: 'reseña').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 02:45:40'!
test19_cuandoUnUsuarioCreaUnDirectorioEsElDueñoDelMismo
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearDirectorioConNombre: 'fotos'.
	
	Assert isTrue: (miniMiUNQ elUsuarioActualEsElDueñoDe: 'fotos').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 02:45:09'!
test20_unUsuarioNoEsDueñoDeUnElementoCreadoPorOtroUsuario
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ crearArchivoConNombre: 'reseña'.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	
	Assert isFalse: (miniMiUNQ elUsuarioActualEsElDueñoDe: 'reseña').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 02:46:09'!
test21_unUsuarioNoEsDueñoDeUnDirectorioCreadoPorOtroUsuario
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ crearDirectorioConNombre: 'fotos'.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	
	Assert isFalse: (miniMiUNQ elUsuarioActualEsElDueñoDe: 'fotos').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 03:10:39'!
test22_cuandoSeCreaUnArchivoElUsuarioActualTienePermisoDeLectura
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	miniMiUNQ crearArchivoConNombre: 'reseña'.
	
	Assert isTrue:  (miniMiUNQ tienePermisoDeLecturaEn: 'reseña').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 03:14:05'!
test23_cuandoSeCreaUnDirectorioElUsuarioActualTienePermisoDeLectura
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	miniMiUNQ crearDirectorioConNombre: 'fotos'.
	
	Assert isTrue:  (miniMiUNQ tienePermisoDeLecturaEn: 'fotos').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 03:10:14'!
test24_cuandoSeCreaUnArchivoElUsuarioActualTienePermisoDeEscritura
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	miniMiUNQ crearArchivoConNombre: 'reseña'.
	
	Assert isTrue:  (miniMiUNQ tienePermisoDeEscrituraEn: 'reseña').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 03:17:35'!
test25_cuandoSeCreaUnDirectorioElUsuarioActualTienePermisoDeEscritura
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	miniMiUNQ crearDirectorioConNombre: 'fotos'.
	
	Assert isTrue:  (miniMiUNQ tienePermisoDeEscrituraEn: 'fotos').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 03:38:13'!
test26_cuandoSeCreaUnArchivoElUsuarioActualTienePermisoDeBorrado
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	miniMiUNQ crearArchivoConNombre: 'reseña'.
	
	Assert isTrue:  (miniMiUNQ tienePermisoDeBorradoEn: 'reseña').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 03:39:12'!
test27_cuandoSeCreaUnDirectorioElUsuarioActualTienePermisoDeBorrado
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	miniMiUNQ crearDirectorioConNombre: 'fotos'.
	
	Assert isTrue:  (miniMiUNQ tienePermisoDeBorradoEn: 'fotos').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 03:42:28'!
test28_elUsuarioRootTienePermisoDeLecturaSobreCualquierArchivo
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	miniMiUNQ crearArchivoConNombre: 'reseña'.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	
	Assert isTrue:  (miniMiUNQ tienePermisoDeLecturaEn: 'reseña').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 03:43:10'!
test29_elUsuarioRootTienePermisoDeLecturaSobreCualquierDirectorio
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	miniMiUNQ crearDirectorioConNombre: 'fotos'.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	
	Assert isTrue:  (miniMiUNQ tienePermisoDeLecturaEn: 'fotos').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 03:43:42'!
test30_elUsuarioRootTienePermisoDeEscrituraSobreCualquierArchivo
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	miniMiUNQ crearArchivoConNombre: 'reseña'.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	
	Assert isTrue:  (miniMiUNQ tienePermisoDeEscrituraEn: 'reseña').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 03:44:05'!
test31_elUsuarioRootTienePermisoDeEscrituraSobreCualquierDirectorio
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	miniMiUNQ crearDirectorioConNombre: 'fotos'.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	
	Assert isTrue:  (miniMiUNQ tienePermisoDeEscrituraEn: 'fotos').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 03:44:31'!
test32_elUsuarioRootTienePermisoDeBorradoSobreCualquierArchivo
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	miniMiUNQ crearArchivoConNombre: 'reseña'.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	
	Assert isTrue:  (miniMiUNQ tienePermisoDeBorradoEn: 'reseña').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 03:44:47'!
test33_elUsuarioRootTienePermisoDeBorradoSobreCualquierDirectorio
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	miniMiUNQ crearDirectorioConNombre: 'fotos'.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	
	Assert isTrue:  (miniMiUNQ tienePermisoDeBorradoEn: 'fotos').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 17:41:59'!
test34_cuandoSeCreaUnArchivoNuevoUnUsuarioQueNoEsDueñoNiRootNoTienePermisoDeLectura

	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearArchivoConNombre: 'reseña'.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'publico' yContraseña: 'publico'.
	
	Assert isFalse:  (miniMiUNQ tienePermisoDeLecturaEn: 'reseña').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 17:22:56'!
test35_cuandoSeCreaUnArchivoYSeLeCambiaElPermisoDeLecturaUnUsuarioQueNoEsDueñoNiRootTienePermisoDeLectura
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearArchivoConNombre: 'Notas'.
	miniMiUNQ cambiarPermisoDe: 'lectura' alElemento: 'Notas'.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'publico' yContraseña: 'publico'.
	
	Assert isTrue:  (miniMiUNQ tienePermisoDeLecturaEn: 'Notas').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 17:21:51'!
test36_cuandoSeCreaUnArchivoYSeLeCambiaElPermisoDeEscrituraUnUsuarioQueNoEsDueñoNiRootTienePermisoDeEscritura
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearArchivoConNombre: 'Notas'.
	miniMiUNQ cambiarPermisoDe: 'escritura' alElemento: 'Notas'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	
	Assert isTrue: (miniMiUNQ tienePermisoDeEscrituraEn: 'Notas').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 17:24:35'!
test37_cuandoSeCreaUnArchivoYSeLeCambiaElPermisoDeBorradoUnUsuarioQueNoEsDueñoNiRootTienePermisoDeBorrado
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearArchivoConNombre: 'Notas'.
	miniMiUNQ cambiarPermisoDe: 'borrado' alElemento: 'Notas'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	
	Assert isTrue: (miniMiUNQ tienePermisoDeBorradoEn: 'Notas').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 17:41:30'!
test38_cuandoSeCreaUnDirectorioNuevoUnUsuarioQueNoEsDueñoNiRootNoTienePermisoDeLectura

	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearDirectorioConNombre: 'fotos'.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'publico' yContraseña: 'publico'.
	
	Assert isFalse:  (miniMiUNQ tienePermisoDeLecturaEn: 'fotos').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 17:42:48'!
test39_cuandoSeCreaUnDirectorioYSeLeCambiaElPermisoDeLecturaUnUsuarioQueNoEsDueñoNiRootTienePermisoDeLectura
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearDirectorioConNombre: 'reseña'.
	miniMiUNQ cambiarPermisoDe: 'lectura' alElemento: 'reseña'.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'publico' yContraseña: 'publico'.
	
	Assert isTrue:  (miniMiUNQ tienePermisoDeLecturaEn: 'reseña').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 17:43:40'!
test40_cuandoSeCreaUnDirectorioYSeLeCambiaElPermisoDeEscrituraUnUsuarioQueNoEsDueñoNiRootTienePermisoDeEscritura
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearDirectorioConNombre: 'reseña'.
	miniMiUNQ cambiarPermisoDe: 'escritura' alElemento: 'reseña'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	
	Assert isTrue: (miniMiUNQ tienePermisoDeEscrituraEn: 'reseña').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 17:44:24'!
test41_cuandoSeCreaUnDirectorioYSeLeCambiaElPermisoDeBorradoUnUsuarioQueNoEsDueñoNiRootTienePermisoDeBorrado
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearDirectorioConNombre: 'reseña'.
	miniMiUNQ cambiarPermisoDe: 'borrado' alElemento: 'reseña'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	
	Assert isTrue: (miniMiUNQ tienePermisoDeBorradoEn: 'reseña').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 17:33:53'!
test42_elUsuarioRootSiempreTienePermisoDeEscrituraDeUnArchivoSinImportarSiSeCambiaElPermiso
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	miniMiUNQ crearArchivoConNombre: 'Notas'.
	miniMiUNQ cambiarPermisoDe: 'escritura' alElemento: 'Notas'. "Agregamos el permiso, ya que está inicializado como privado"
	miniMiUNQ cambiarPermisoDe: 'escritura' alElemento: 'Notas'.	 "Y acá se lo quitamos."
	
	Assert isTrue: (miniMiUNQ tienePermisoDeEscrituraEn: 'Notas').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 18:16:15'!
test43a_elDueñoDeUnArchivoSigueTeniendoPermisoDeEscrituraCuandoSeCambiaElPermisoDeEscritura
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	miniMiUNQ crearArchivoConNombre: 'Notas'.
	miniMiUNQ cambiarPermisoDe: 'escritura' alElemento: 'Notas'. "Agregamos el permiso, ya que está inicializado como privado"
	miniMiUNQ cambiarPermisoDe: 'escritura' alElemento: 'Notas'.	 "Y acá se lo quitamos."
	
	Assert isTrue: (miniMiUNQ tienePermisoDeEscrituraEn: 'Notas').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 18:16:06'!
test43b_elUsuarioRootSiempreTienePermisoDeBorradoDeUnArchivoSinImportarSiSeCambiaElPermiso
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	miniMiUNQ crearArchivoConNombre: 'Notas'.
	miniMiUNQ cambiarPermisoDe: 'borrado' alElemento: 'Notas'. "Agregamos el permiso, ya que está inicializado como privado"
	miniMiUNQ cambiarPermisoDe: 'borrado' alElemento: 'Notas'.	 "Y acá se lo quitamos."
	
	Assert isTrue: (miniMiUNQ tienePermisoDeBorradoEn: 'Notas').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 17:40:21'!
test44_elDueñoDeUnArchivoSigueTeniendoPermisoDeBorradoCuandoSeCambiaElPermisoDeBorrado
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	miniMiUNQ crearArchivoConNombre: 'Notas'.
	miniMiUNQ cambiarPermisoDe: 'borrado' alElemento: 'Notas'. "Agregamos el permiso, ya que está inicializado como privado"
	miniMiUNQ cambiarPermisoDe: 'borrado' alElemento: 'Notas'.	 "Y acá se lo quitamos."
	
	Assert isTrue: (miniMiUNQ tienePermisoDeBorradoEn: 'Notas').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 17:40:28'!
test45_elUsuarioRootSiempreTienePermisoDeLecturaDeUnArchivoSinImportarSiSeCambiaElPermiso
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	miniMiUNQ crearArchivoConNombre: 'Notas'.
	miniMiUNQ cambiarPermisoDe: 'lectura' alElemento: 'Notas'. "Agregamos el permiso, ya que está inicializado como privado"
	miniMiUNQ cambiarPermisoDe: 'lectura' alElemento: 'Notas'.	 "Y acá se lo quitamos."
	
	Assert isTrue: (miniMiUNQ tienePermisoDeLecturaEn: 'Notas').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 17:40:37'!
test46_elDueñoDeUnArchivoSigueTeniendoPermisoDeLecturaCuandoSeCambiaElPermisoDeLectura
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	miniMiUNQ crearArchivoConNombre: 'Notas'.
	miniMiUNQ cambiarPermisoDe: 'lectura' alElemento: 'Notas'. "Agregamos el permiso, ya que está inicializado como privado"
	miniMiUNQ cambiarPermisoDe: 'lectura' alElemento: 'Notas'.	 "Y acá se lo quitamos."
	
	Assert isTrue: (miniMiUNQ tienePermisoDeLecturaEn: 'Notas').! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 17:57:23'!
test47_unUsuarioQueNoPoseePermisosDeEscrituraEnUnDirectorioNoPuedeCrearElementos
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearDirectorioConNombre: 'reseña'.
	miniMiUNQ cambiarPermisoDe: 'escritura' alElemento: 'reseña'. "Agregamos el permiso, ya que está inicializado como privado"
	miniMiUNQ cambiarPermisoDe: 'escritura' alElemento: 'reseña'.	 "Y acá se lo quitamos."
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	miniMiUNQ accederADirectorio: 'reseña'.
	
	
	Assert should: [miniMiUNQ crearDirectorioConNombre: 'documentos']
			  signal: Error - MessageNotUnderstood 
			  withDescription: 'No tenes permisos suficientes para realizar esta accion'.! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 18:19:57'!
test48_unUsuarioQueNoPoseePermisosDeEscrituraEnUnArchivoNoPuedeModificarElContenidoDelMismo
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearArchivoConNombre: 'notas'.
	miniMiUNQ cambiarPermisoDe: 'escritura' alElemento: 'notas'. "Agregamos el permiso, ya que está inicializado como privado"
	miniMiUNQ cambiarPermisoDe: 'escritura' alElemento: 'notas'.	 "Y acá se lo quitamos."
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	
	
	Assert should: [miniMiUNQ escribir: 'comprar pan' en: 'notas']
			  signal: Error - MessageNotUnderstood 
			  withDescription: 'No tenes permisos suficientes para realizar esta accion'.! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 18:18:47'!
test49_unUsuarioQueNoPoseePermisosDeLecturaEnUnArchivoNoPuedeAccederAlContenidoDelMismo
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearArchivoConNombre: 'notas'.
	miniMiUNQ cambiarPermisoDe: 'lectura' alElemento: 'notas'. "Agregamos el permiso, ya que está inicializado como privado"
	miniMiUNQ cambiarPermisoDe: 'lectura' alElemento: 'notas'.	 "Y acá se lo quitamos."
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	
	
	Assert should: [miniMiUNQ leerTextoDeArchivo: 'notas']
			  signal: Error - MessageNotUnderstood 
			  withDescription: 'No tenes permisos suficientes para realizar esta accion'.! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 18:24:34'!
test50_unUsuarioQueNoPoseePermisosDeBorradoEnUnArchivoNoPuedeEliminarlo
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearArchivoConNombre: 'notas'.
	miniMiUNQ cambiarPermisoDe: 'borrado' alElemento: 'notas'. "Agregamos el permiso, ya que está inicializado como privado"
	miniMiUNQ cambiarPermisoDe: 'borrado' alElemento: 'notas'.	 "Y acá se lo quitamos."
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	
	
	Assert should: [miniMiUNQ borrarElementoConNombre: 'notas']
			  signal: Error - MessageNotUnderstood 
			  withDescription: 'No tenes permisos suficientes para realizar esta accion'.! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/4/2022 18:29:00'!
test51_unUsuarioQueNoPoseePermisosDeBorradoEnUnDirectorioNoPuedeEliminarlo
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearDirectorioConNombre: 'reseña'.
	miniMiUNQ cambiarPermisoDe: 'borrado' alElemento: 'reseña'. "Agregamos el permiso, ya que está inicializado como privado"
	miniMiUNQ cambiarPermisoDe: 'borrado' alElemento: 'reseña'.	 "Y acá se lo quitamos."
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	
	
	Assert should: [miniMiUNQ borrarElementoConNombre: 'reseña']
			  signal: Error - MessageNotUnderstood 
			  withDescription: 'No tenes permisos suficientes para realizar esta accion'.! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/6/2022 20:52:02'!
test52_cuandoSeCreaUnDirectorioYSeComparteConOtroUsuario_EsteQuedaRegistrado
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearDirectorioConNombre: 'reseña'.
	miniMiUNQ cambiarPermisoDe: 'lectura' alElemento: 'reseña'.
	miniMiUNQ compartirElemento: 'reseña' conUsuario: unUsuarioPublico.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'publico' yContraseña: 'publico'.
	
	Assert isTrue:  (miniMiUNQ tienePermisoDeLecturaEn: 'reseña').
	Assert that: (miniMiUNQ directorioActual darElementoConNombre: 'reseña') usuariosCompartidos isEqualTo: (Set with: unUsuarioPublico).! !

!MiniMiUNQTest methodsFor: 'elementos-tests' stamp: 'jdm 12/6/2022 20:55:03'!
test53_cuandoSeCreaUnArchivoYSeComparteConOtrosDosUsuarios_EstosQuedanRegistrados
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearArchivoConNombre: 'notas'.
	miniMiUNQ compartirElemento: 'notas' conUsuario: unUsuarioPublico.
	miniMiUNQ compartirElemento: 'notas' conUsuario: unUsuarioComun.
	
	Assert that: (miniMiUNQ directorioActual darElementoConNombre: 'notas') usuariosCompartidos isEqualTo: (Set with: unUsuarioPublico with: unUsuarioComun).! !


!MiniMiUNQTest methodsFor: 'usuarios-tests' stamp: 'jdm 12/1/2022 14:51:01'!
test01_cuandoSeInicializaUnSistemaMiniMiUNQtiene2UsuariosRegistrados

	Assert that: miniMiUNQ cantidadDeUsuariosRegistrados isEqualTo: 2.! !

!MiniMiUNQTest methodsFor: 'usuarios-tests' stamp: 'jdm 12/2/2022 15:10:52'!
test02_cuandoSeInicializaUnSistemaMiniMiUNQElUsuarioActualEsElPublico
	
	Assert that: miniMiUNQ usuarioActual isEqualTo: unUsuarioPublico.
! !

!MiniMiUNQTest methodsFor: 'usuarios-tests' stamp: 'jdm 12/1/2022 14:56:57'!
test03_cuandoUnUsuarioRootSeLogueaEnElSistema_EstePasaASerElUsuarioActual
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	
	self assert: miniMiUNQ usuarioActual equals: unUsuarioRoot.! !

!MiniMiUNQTest methodsFor: 'usuarios-tests' stamp: 'jdm 12/1/2022 15:02:44'!
test04_cuandoUnUsuarioRootIntentaLoguearseIncorrectamenteEnElSistema_ElLoginEsInvalido

	self should: [miniMiUNQ iniciarSesionConNombreDeUsuario: 'francoBeltra1' yContraseña: '123']
	 raise: Error 
	withMessageText: 'Nombre de usuario o contraseña invalida'.
	! !

!MiniMiUNQTest methodsFor: 'usuarios-tests' stamp: 'jdm 12/1/2022 15:09:03'!
test05_cuandoUnUsuarioRootAgregaAUnUsuarioComun_ElSistemaLoRegistra

	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	
	Assert that: miniMiUNQ cantidadDeUsuariosRegistrados isEqualTo: 3.
	
	! !

!MiniMiUNQTest methodsFor: 'usuarios-tests' stamp: 'jdm 12/1/2022 16:30:24'!
test06_cuandoUnUsuarioRootAgregaAUnUsuarioAdministrador_ElSistemaLoRegistra

	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioAdministrador.
	
	Assert that: miniMiUNQ cantidadDeUsuariosRegistrados isEqualTo: 3.
	
	! !

!MiniMiUNQTest methodsFor: 'usuarios-tests' stamp: 'jdm 12/1/2022 16:33:01'!
test07_cuandoUnUsuarioRootAgregaAUnUsuarioRoot_ElSistemaLanzaError

	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	
	Assert should: [miniMiUNQ agregarUsuario: otroUsuarioRoot] 
	signal: Error - MessageNotUnderstood
	withDescription: 'El usuario que quiere añadir ya existe o es un usuario root'.
	
	! !

!MiniMiUNQTest methodsFor: 'usuarios-tests' stamp: 'jdm 12/1/2022 16:24:47'!
test08_cuandoUnUsuarioRootAgregaAUnUsuarioQueYaEstaRegistrado_ElSistemaLanzaError

	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	
	Assert should: [miniMiUNQ agregarUsuario: unUsuarioComun] 
	signal: Error - MessageNotUnderstood
	withDescription: 'El usuario que quiere añadir ya existe o es un usuario root'.
	
	! !

!MiniMiUNQTest methodsFor: 'usuarios-tests' stamp: 'jdm 12/1/2022 16:27:49'!
test09_cuandoUnUsuarioAdministradorAgregaAUnUsuarioComun_ElSistemaLoRegistra

	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioAdministrador.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'admin' yContraseña: 'admin'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	
	Assert that: miniMiUNQ cantidadDeUsuariosRegistrados isEqualTo: 4.
	Assert that: miniMiUNQ usuarioActual isEqualTo: unUsuarioAdministrador.
	
	! !

!MiniMiUNQTest methodsFor: 'usuarios-tests' stamp: 'jdm 12/1/2022 16:28:55'!
test10_cuandoUnUsuarioAdministradorAgregaAUnUsuarioAdministrador_ElSistemaLoRegistra

	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioAdministrador.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'admin' yContraseña: 'admin'.
	miniMiUNQ agregarUsuario: otroUsuarioAdministrador.
	
	Assert that: miniMiUNQ cantidadDeUsuariosRegistrados isEqualTo: 4.
	Assert that: miniMiUNQ usuarioActual isEqualTo: unUsuarioAdministrador.
	
	! !

!MiniMiUNQTest methodsFor: 'usuarios-tests' stamp: 'jdm 12/1/2022 16:33:49'!
test11_cuandoUnUsuarioAdministradorAgregaAUnUsuarioRoot_ElSistemaLanzaError

	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioAdministrador.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'admin' yContraseña: 'admin'.
	
	Assert that: miniMiUNQ cantidadDeUsuariosRegistrados isEqualTo: 3.
	
	Assert should: [miniMiUNQ agregarUsuario: otroUsuarioRoot] 
	signal: Error - MessageNotUnderstood
	withDescription: 'El usuario que quiere añadir ya existe o es un usuario root'.
	
	! !

!MiniMiUNQTest methodsFor: 'usuarios-tests' stamp: 'jdm 12/1/2022 22:32:53'!
test12_cuandoUnUsuarioRootDaDeBajaAUnUsuarioAdministrador_ElSistemaLoElimina

	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioAdministrador.
	miniMiUNQ darDeBajaA: unUsuarioAdministrador.
	
	Assert that: miniMiUNQ cantidadDeUsuariosRegistrados isEqualTo: 2.
	
	
	! !

!MiniMiUNQTest methodsFor: 'usuarios-tests' stamp: 'jdm 12/4/2022 14:04:16'!
test13A_cuandoUnUsuarioRootQuiereDarDeBajaAUnUsuarioAdministradorQueNoEstaRegistrado_ElSistemaLanzaError

	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	
	Assert should: [miniMiUNQ darDeBajaA: unUsuarioAdministrador] 
	signal: Error - MessageNotUnderstood
	withDescription: 'El usuario que quiere dar de baja no esta registrado'.
	
	Assert that: miniMiUNQ cantidadDeUsuariosRegistrados isEqualTo: 2.
	
	! !

!MiniMiUNQTest methodsFor: 'usuarios-tests' stamp: 'jdm 12/4/2022 14:22:54'!
test13B_cuandoUnUsuarioAdministradorQuiereDarDeBajaACualquierUsuario_ElSistemaLanzaError

	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioAdministrador.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'admin' yContraseña: 'admin'.
	
	Assert should: [miniMiUNQ darDeBajaA: unUsuarioComun] 
			signal: Error - MessageNotUnderstood 
			withDescription: 'No tenes los permisos suficientes para realizar esta accion'.
	

	! !

!MiniMiUNQTest methodsFor: 'usuarios-tests' stamp: 'jdm 12/4/2022 14:26:35'!
test13C_cuandoUnUsuarioComunQuiereDarDeBajaACualquierUsuario_ElSistemaLanzaError

	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioAdministrador.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	
	Assert should: [miniMiUNQ darDeBajaA: unUsuarioAdministrador] 
			signal: Error - MessageNotUnderstood 
			withDescription: 'No tenes los permisos suficientes para realizar esta accion'.
	! !

!MiniMiUNQTest methodsFor: 'usuarios-tests' stamp: 'jdm 12/1/2022 22:38:13'!
test14_cuandoUnUsuarioRootModificaAUnUsuarioAdministrador_ElSistemaModificaSusCredenciales

	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioAdministrador.
	miniMiUNQ modificarUsuario: unUsuarioAdministrador conNuevoNombreDeUsuario: 'pepe' conNuevaContraseña: '123'.
	
	Assert that: unUsuarioAdministrador nombre isEqualTo: 'pepe'.
	Assert that: unUsuarioAdministrador contraseña isEqualTo: '123'.
	
	! !

!MiniMiUNQTest methodsFor: 'usuarios-tests' stamp: 'jdm 12/1/2022 22:45:49'!
test15_cuandoUnUsuarioRootModificaAUnUsuarioComun_ElSistemaModificaSusCredenciales

	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ modificarUsuario: unUsuarioComun conNuevoNombreDeUsuario: 'pepita' conNuevaContraseña: '321'.
	
	Assert that: unUsuarioComun nombre isEqualTo: 'pepita'.
	Assert that: unUsuarioComun contraseña isEqualTo: '321'.
	
	! !

!MiniMiUNQTest methodsFor: 'usuarios-tests' stamp: 'jdm 12/1/2022 22:46:58'!
test16_cuandoUnUsuarioRootSeModificaASiMismo_ElSistemaModificaSusCredenciales

	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ modificarUsuario: unUsuarioRoot conNuevoNombreDeUsuario: 'elmascapo' conNuevaContraseña: '879'.
	
	Assert that: unUsuarioRoot nombre isEqualTo: 'elmascapo'.
	Assert that: unUsuarioRoot contraseña isEqualTo: '879'.
	
	! !

!MiniMiUNQTest methodsFor: 'usuarios-tests' stamp: 'jdm 12/1/2022 22:52:07'!
test17_cuandoUnUsuarioAdministradorModificaAUnUsuarioComun_ElSistemaModificaSusCredenciales

	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioAdministrador.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'admin' yContraseña: 'admin'.
	miniMiUNQ modificarUsuario: unUsuarioComun conNuevoNombreDeUsuario: 'hola' conNuevaContraseña: '423'.
	
	Assert that: unUsuarioComun nombre isEqualTo: 'hola'.
	Assert that: unUsuarioComun contraseña isEqualTo: '423'.
	
	! !

!MiniMiUNQTest methodsFor: 'usuarios-tests' stamp: 'jdm 12/1/2022 23:09:50'!
test18_cuandoUnUsuarioAdministradorModificaAUnUsuarioAdministrador_ElSistemaLanzaError

	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioAdministrador.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'admin' yContraseña: 'admin'.
	miniMiUNQ agregarUsuario: otroUsuarioAdministrador.
	
	
	Assert should: [miniMiUNQ modificarUsuario: otroUsuarioAdministrador conNuevoNombreDeUsuario: 'hola' conNuevaContraseña: '423'] 
	signal: Error - MessageNotUnderstood
	withDescription: 'No tenes los permisos suficientes para realizar esta accion o el usuario que deseas modificar no esta registrado'.
	
	
	! !

!MiniMiUNQTest methodsFor: 'usuarios-tests' stamp: 'jdm 12/1/2022 23:38:03'!
test19_cuandoUnUsuarioAdministradorModificaAUnUsuarioRoot_ElSistemaLanzaError

	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioAdministrador.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'admin' yContraseña: 'admin'.
	
	Assert should: [miniMiUNQ modificarUsuario: unUsuarioRoot conNuevoNombreDeUsuario: 'hola' conNuevaContraseña: '423'] 
	signal: Error - MessageNotUnderstood
	withDescription: 'No tenes los permisos suficientes para realizar esta accion o el usuario que deseas modificar no esta registrado'.
	
	
	! !

!MiniMiUNQTest methodsFor: 'usuarios-tests' stamp: 'jdm 12/2/2022 00:29:02'!
test20_cuandoUnUsuarioAdministradorSeLogueaEnElSistema_EstePasaASerElUsuarioActual
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioAdministrador.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'admin' yContraseña: 'admin'.
	
	self assert: miniMiUNQ usuarioActual equals: unUsuarioAdministrador.! !

!MiniMiUNQTest methodsFor: 'usuarios-tests' stamp: 'jdm 12/2/2022 00:29:10'!
test21_cuandoUnUsuarioAdministradorIntentaLoguearseIncorrectamenteEnElSistema_ElLoginEsInvalido

	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioAdministrador.
	self should: [miniMiUNQ iniciarSesionConNombreDeUsuario: 'adsdad' yContraseña: 'admin']
	 raise: Error 
	withMessageText: 'Nombre de usuario o contraseña invalida'.
	! !

!MiniMiUNQTest methodsFor: 'usuarios-tests' stamp: 'jdm 12/2/2022 00:29:16'!
test22_cuandoUnUsuarioAdministradorIntentaLoguearseCorrectamentePeroNoEstaRegistradoEnElSistema_ElLoginEsInvalido

	self should: [miniMiUNQ iniciarSesionConNombreDeUsuario: 'admin' yContraseña: 'admin']
	 raise: Error 
	withMessageText: 'Nombre de usuario o contraseña invalida'.
	! !

!MiniMiUNQTest methodsFor: 'usuarios-tests' stamp: 'jdm 12/2/2022 00:29:21'!
test23_cuandoUnUsuarioComunSeLogueaEnElSistema_EstePasaASerElUsuarioActual
	
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	
	self assert: miniMiUNQ usuarioActual equals: unUsuarioComun.! !

!MiniMiUNQTest methodsFor: 'usuarios-tests' stamp: 'jdm 12/2/2022 00:29:26'!
test24_cuandoUnUsuarioComunIntentaLoguearseIncorrectamenteEnElSistema_ElLoginEsInvalido

	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	self should: [miniMiUNQ iniciarSesionConNombreDeUsuario: 'adsdad' yContraseña: 'comun']
	 raise: Error 
	withMessageText: 'Nombre de usuario o contraseña invalida'.
	! !

!MiniMiUNQTest methodsFor: 'usuarios-tests' stamp: 'jdm 12/2/2022 00:29:56'!
test25_cuandoUnUsuarioComunIntentaLoguearseCorrectamentePeroNoEstaRegistradoEnElSistema_ElLoginEsInvalido

	self should: [miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun']
	 raise: Error 
	withMessageText: 'Nombre de usuario o contraseña invalida'.
	! !


!MiniMiUNQTest methodsFor: 'filtros-tests' stamp: 'jdm 12/6/2022 20:48:40'!
test01_unSistemaMiniMiUNQPuedeFiltrarEnElDirectorioActualSusArchivosPorContenidoDeTexto
	
	| elementosFiltrados |
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearDirectorioConNombre: 'recetas'.
	miniMiUNQ accederADirectorio: 'recetas'.
	miniMiUNQ crearArchivoConNombre: 'receta1'.
	miniMiUNQ escribir: 'Esta receta es de fideos con tuco' en: 'receta1'.
	miniMiUNQ crearArchivoConNombre: 'receta2'.
	miniMiUNQ escribir: 'Esta receta es de fideos con pesto' en: 'receta2'.
	miniMiUNQ crearArchivoConNombre: 'receta3'.
	miniMiUNQ escribir: 'Esta receta es de bondiola a la bbq' en: 'receta3'.
	
	elementosFiltrados _ miniMiUNQ filtrarPor: { FiltroPorContenidoDeTexto conContenidoDeTexto: 'fideos' }.
	
	Assert that: elementosFiltrados size isEqualTo: 2.! !

!MiniMiUNQTest methodsFor: 'filtros-tests' stamp: 'jdm 12/5/2022 23:38:13'!
test02_unSistemaMiniMiUNQPuedeFiltrarEnElDirectorioActualSusArchivosPorFechaDeCreacion
	
	| elementosFiltrados |
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearDirectorioConNombre: 'recetas'.
	miniMiUNQ accederADirectorio: 'recetas'.
	miniMiUNQ crearArchivoConNombre: 'receta1'.
	miniMiUNQ escribir: 'Esta receta es de fideos con tuco' en: 'receta1'.
	miniMiUNQ crearArchivoConNombre: 'receta2'.
	miniMiUNQ escribir: 'Esta receta es de fideos con pesto' en: 'receta2'.
	miniMiUNQ crearArchivoConNombre: 'receta3'.
	miniMiUNQ escribir: 'Esta receta es de bondiola a la bbq' en: 'receta3'.
	
	elementosFiltrados _ miniMiUNQ filtrarPor: { FiltroPorFechaDeCreacion conFechaDeCreacion: self fechaDelDiaDeHoy}.
	
	Assert that: elementosFiltrados size isEqualTo: 3.! !

!MiniMiUNQTest methodsFor: 'filtros-tests' stamp: 'jdm 12/5/2022 23:43:46'!
test03_unSistemaMiniMiUNQPuedeFiltrarEnElDirectorioActualSusArchivosPorDueño
	
	| elementosFiltrados |
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ crearDirectorioConNombre: 'recetas'.
	miniMiUNQ accederADirectorio: 'recetas'.
	miniMiUNQ crearArchivoConNombre: 'receta1'.
	miniMiUNQ crearArchivoConNombre: 'receta2'.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	miniMiUNQ crearArchivoConNombre: 'receta3'.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ crearDirectorioConNombre: 'guarniciones'.

	elementosFiltrados _ miniMiUNQ filtrarPor: { FiltroPorDueño conDueño: unUsuarioRoot}.
	
	Assert that: elementosFiltrados size isEqualTo: 2.! !

!MiniMiUNQTest methodsFor: 'filtros-tests' stamp: 'jdm 12/5/2022 23:46:58'!
test04_unSistemaMiniMiUNQPuedeFiltrarEnElDirectorioActualLosArchivosQueTenganPermisoDeLectura
	
	| elementosFiltrados |
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ crearDirectorioConNombre: 'recetas'.
	miniMiUNQ accederADirectorio: 'recetas'.
	miniMiUNQ crearArchivoConNombre: 'receta1'.
	miniMiUNQ crearArchivoConNombre: 'receta2'.
	miniMiUNQ cambiarPermisoDe: 'lectura' alElemento: 'receta1'.
	miniMiUNQ cambiarPermisoDe: 'lectura' alElemento: 'receta2'.

	elementosFiltrados _ miniMiUNQ filtrarPor: { FiltroPorPermisos conPermisoDe: 'lectura'}.
	
	Assert that: elementosFiltrados size isEqualTo: 2.! !

!MiniMiUNQTest methodsFor: 'filtros-tests' stamp: 'jdm 12/5/2022 23:48:54'!
test05_unSistemaMiniMiUNQPuedeFiltrarEnElDirectorioActualLosArchivosQueTenganPermisoDeEscritura
	
	| elementosFiltrados |
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ crearDirectorioConNombre: 'recetas'.
	miniMiUNQ accederADirectorio: 'recetas'.
	miniMiUNQ crearArchivoConNombre: 'receta1'.
	miniMiUNQ crearArchivoConNombre: 'receta2'.
	miniMiUNQ cambiarPermisoDe: 'escritura' alElemento: 'receta1'.


	elementosFiltrados _ miniMiUNQ filtrarPor: { FiltroPorPermisos conPermisoDe: 'escritura'}.
	
	Assert that: elementosFiltrados size isEqualTo: 1.! !

!MiniMiUNQTest methodsFor: 'filtros-tests' stamp: 'jdm 12/5/2022 23:49:11'!
test06_unSistemaMiniMiUNQPuedeFiltrarEnElDirectorioActualLosArchivosQueTenganPermisoDeBorrado
	
	| elementosFiltrados |
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ crearDirectorioConNombre: 'recetas'.
	miniMiUNQ accederADirectorio: 'recetas'.
	miniMiUNQ crearArchivoConNombre: 'receta1'.
	miniMiUNQ crearArchivoConNombre: 'receta2'.
	miniMiUNQ crearArchivoConNombre: 'receta3'.
	miniMiUNQ cambiarPermisoDe: 'borrado' alElemento: 'receta1'.


	elementosFiltrados _ miniMiUNQ filtrarPor: { FiltroPorPermisos conPermisoDe: 'borrado'}.
	
	Assert that: elementosFiltrados size isEqualTo: 1.! !

!MiniMiUNQTest methodsFor: 'filtros-tests' stamp: 'jdm 12/5/2022 23:54:44'!
test07_unSistemaMiniMiUNQPuedeFiltrarEnElDirectorioActualLosArchivosCombinandoFiltroPorContenidoDeTextoYPorDueño
	
	| elementosFiltrados |
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ crearDirectorioConNombre: 'recetas'.
	miniMiUNQ accederADirectorio: 'recetas'.
	miniMiUNQ crearArchivoConNombre: 'receta1'.
	miniMiUNQ escribir: 'Esta receta es de fideos con tuco' en: 'receta1'.
	miniMiUNQ crearArchivoConNombre: 'receta3'.
	miniMiUNQ escribir: 'Esta receta es de bondiola a la bbq' en: 'receta3'.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	miniMiUNQ crearArchivoConNombre: 'receta2'.
	miniMiUNQ escribir: 'Esta receta es de fideos con pesto' en: 'receta2'.


	elementosFiltrados _ miniMiUNQ filtrarPor: { FiltroPorContenidoDeTexto conContenidoDeTexto: 'fideos' .
										 FiltroPorDueño conDueño: unUsuarioRoot}.
	
	Assert that: elementosFiltrados size isEqualTo: 1.! !

!MiniMiUNQTest methodsFor: 'filtros-tests' stamp: 'jdm 12/6/2022 00:00:02'!
test08_unSistemaMiniMiUNQPuedeFiltrarEnElDirectorioActualLosArchivosCombinandoTodosLosFiltros
	
	| elementosFiltrados |
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'root' yContraseña: 'root'.
	miniMiUNQ agregarUsuario: unUsuarioComun.
	miniMiUNQ crearDirectorioConNombre: 'recetas'.
	miniMiUNQ accederADirectorio: 'recetas'.
	miniMiUNQ crearArchivoConNombre: 'receta1'.
	miniMiUNQ escribir: 'Esta receta es de fideos con tuco' en: 'receta1'.
	miniMiUNQ cambiarPermisoDe: 'borrado' alElemento: 'receta1'.
	miniMiUNQ crearArchivoConNombre: 'receta3'.
	miniMiUNQ escribir: 'Esta receta es de bondiola a la bbq' en: 'receta3'.
	miniMiUNQ iniciarSesionConNombreDeUsuario: 'comun' yContraseña: 'comun'.
	miniMiUNQ crearArchivoConNombre: 'receta2'.
	miniMiUNQ escribir: 'Esta receta es de fideos con pesto' en: 'receta2'.
	miniMiUNQ crearArchivoConNombre: 'receta4'.
	miniMiUNQ escribir: 'Esta receta es de fideos con manteca' en: 'receta4'.
	miniMiUNQ cambiarPermisoDe: 'lectura' alElemento: 'receta2'.
	miniMiUNQ cambiarPermisoDe: 'borrado' alElemento: 'receta4'.


	elementosFiltrados _ miniMiUNQ filtrarPor: { FiltroPorContenidoDeTexto conContenidoDeTexto: 'fideos'.
									     FiltroPorDueño conDueño: unUsuarioComun .
									     FiltroPorFechaDeCreacion conFechaDeCreacion: self fechaDelDiaDeHoy .
									     FiltroPorPermisos conPermisoDe: 'borrado' }.
	
	Assert that: elementosFiltrados size isEqualTo: 1.! !


!classDefinition: #ArchivoDeMentira category: 'tpFinalGrupo3'!
Object subclass: #ArchivoDeMentira
	instanceVariableNames: 'contenido'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'tpFinalGrupo3'!

!ArchivoDeMentira methodsFor: 'initialize' stamp: 'jdm 12/8/2022 12:21:07'!
initialize
	contenido _ ReadWriteStream on: ''.! !


!ArchivoDeMentira methodsFor: 'accessing' stamp: 'jdm 12/8/2022 12:20:05'!
contenido
	^ contenido contents.! !

!ArchivoDeMentira methodsFor: 'accessing' stamp: 'jdm 12/8/2022 12:20:33'!
fileContents
	^contenido.! !


!ArchivoDeMentira methodsFor: 'actions' stamp: 'jdm 12/8/2022 12:20:56'!
forceWriteStreamDo: aBlockClosure 
	aBlockClosure value: contenido.! !


!classDefinition: #Elemento category: 'tpFinalGrupo3'!
Object subclass: #Elemento
	instanceVariableNames: 'dueño fechaDeCreacion nombre permisos usuariosCompartidos'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'tpFinalGrupo3'!

!Elemento methodsFor: 'testing' stamp: 'jdm 12/4/2022 16:05:18'!
contenido

	self subclassResponsibility.! !

!Elemento methodsFor: 'testing' stamp: 'jdm 12/4/2022 02:42:01'!
elElemento: unNombreDeElemento tieneComoDueñoA: unUsuario 
	
	^(self darElementoConNombre: unNombreDeElemento) tieneComoDueñoA: unUsuario.! !

!Elemento methodsFor: 'testing' stamp: 'jdm 12/4/2022 16:03:02'!
esDirectorio

	self subclassResponsibility.! !

!Elemento methodsFor: 'testing' stamp: 'jdm 12/4/2022 16:06:26'!
escribir: unContenidoDeTexto
	
	self subclassResponsibility.! !

!Elemento methodsFor: 'testing' stamp: 'jdm 12/4/2022 17:25:26'!
permisoDeBorrado
	
	^ permisos anySatisfy: [: unPermiso | unPermiso = 'borrado'].! !

!Elemento methodsFor: 'testing' stamp: 'jdm 12/4/2022 03:36:20'!
permisoDeBorradoDelElemento: unNombreDeElemento

	^ (self darElementoConNombre: unNombreDeElemento ) permisoDeBorrado.! !

!Elemento methodsFor: 'testing' stamp: 'jdm 12/4/2022 03:16:10'!
permisoDeEscritura
	
	^ permisos anySatisfy: [: unPermiso | unPermiso = 'escritura'].! !

!Elemento methodsFor: 'testing' stamp: 'jdm 12/4/2022 03:15:49'!
permisoDeEscrituraDelElemento: unNombreDelElemento
	
	^ (self darElementoConNombre: unNombreDelElemento) permisoDeEscritura.! !

!Elemento methodsFor: 'testing' stamp: 'jdm 12/4/2022 03:06:22'!
permisoDeLectura
	
	^ permisos anySatisfy: [: unPermiso | unPermiso = 'lectura'].! !

!Elemento methodsFor: 'testing' stamp: 'jdm 12/4/2022 03:05:32'!
permisoDeLecturaDelElemento: unNombreDeElemento
	
	^ (self darElementoConNombre: unNombreDeElemento ) permisoDeLectura.! !

!Elemento methodsFor: 'testing' stamp: 'jdm 12/5/2022 22:58:07'!
permisos
	^permisos.! !

!Elemento methodsFor: 'testing' stamp: 'jdm 12/2/2022 23:12:45'!
tieneComoDueñoA: unUsuario
	^ dueño = unUsuario.! !

!Elemento methodsFor: 'testing' stamp: 'jdm 12/4/2022 16:06:52'!
tieneElNombre: unNombreDeElemento 
	^ nombre = unNombreDeElemento.! !

!Elemento methodsFor: 'testing' stamp: 'jdm 12/5/2022 22:59:32'!
tienePermisoDe: unPermiso 
	
	^ permisos includes: unPermiso.! !


!Elemento methodsFor: 'initialize' stamp: 'jdm 12/2/2022 23:10:33'!
initializeConNombre: unNombreDeArchivo conDueño: unUsuario conFechaDeCreacion: unaFecha 
	nombre := unNombreDeArchivo.
	dueño := unUsuario.
	fechaDeCreacion := unaFecha.! !


!Elemento methodsFor: 'accessing' stamp: 'jdm 12/4/2022 19:25:20'!
dueño
	^dueño.! !

!Elemento methodsFor: 'accessing' stamp: 'jdm 12/5/2022 22:29:57'!
fechaDeCreacion
	^fechaDeCreacion.! !

!Elemento methodsFor: 'accessing' stamp: 'jdm 12/8/2022 00:17:30'!
fechaDeCreacionComoString
	^ fechaDeCreacion asString.! !

!Elemento methodsFor: 'accessing' stamp: 'jdm 12/3/2022 00:31:57'!
nombre
	^nombre! !

!Elemento methodsFor: 'accessing' stamp: 'jdm 12/6/2022 20:23:55'!
usuariosCompartidos
	^usuariosCompartidos.! !


!Elemento methodsFor: 'actions' stamp: 'jdm 12/6/2022 20:44:39'!
agregarAUsuariosCompartidosElUsuario: unUsuario
	
	usuariosCompartidos add: unUsuario.! !

!Elemento methodsFor: 'actions' stamp: 'jdm 12/4/2022 17:21:44'!
cambiarPermisoDe: unPermiso 
	permisos remove: unPermiso ifAbsent: [permisos add: unPermiso]! !

!Elemento methodsFor: 'actions' stamp: 'jdm 12/5/2022 22:50:04'!
esArchivo
	self subclassResponsibility.! !

!Elemento methodsFor: 'actions' stamp: 'jdm 12/6/2022 23:49:31'!
printUsuariosCompartidos
	| impresion |
	
	impresion:= ReadWriteStream with: ''.
	
	usuariosCompartidos do: [: unUsuario | impresion nextPutAll: unUsuario nombre, '/'].
										
	^ impresion contents.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Elemento class' category: 'tpFinalGrupo3'!
Elemento class
	instanceVariableNames: ''!

!Elemento class methodsFor: 'instance creation' stamp: 'jdm 12/4/2022 19:23:37'!
conNombre: unNombreDeArchivo conDueño: unUsuario conFecha: unaFecha 

	^self new initializeConNombre: unNombreDeArchivo conDueño: unUsuario conFechaDeCreacion: unaFecha. ! !


!classDefinition: #Archivo category: 'tpFinalGrupo3'!
Elemento subclass: #Archivo
	instanceVariableNames: 'contenido'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'tpFinalGrupo3'!

!Archivo methodsFor: 'initialize' stamp: 'jdm 12/6/2022 20:45:34'!
initialize
	"Que el colaborador permisos sea un set vacio, representa la falta de permisos, es decir, es privado"
	
	contenido _ ''.
	permisos _ Set new.
	usuariosCompartidos _ Set new.
	! !


!Archivo methodsFor: 'testing' stamp: 'jdm 12/5/2022 22:49:26'!
esArchivo
	^true.! !

!Archivo methodsFor: 'testing' stamp: 'jdm 12/3/2022 01:20:02'!
esDirectorio
	^false.! !


!Archivo methodsFor: 'accessing' stamp: 'jdm 12/4/2022 02:11:25'!
contenido
	^contenido.! !


!Archivo methodsFor: 'action' stamp: 'jdm 12/4/2022 02:23:44'!
escribir: unContenidoEnTexto

	contenido _ contenido , unContenidoEnTexto.! !


!classDefinition: #Directorio category: 'tpFinalGrupo3'!
Elemento subclass: #Directorio
	instanceVariableNames: 'elementos'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'tpFinalGrupo3'!

!Directorio methodsFor: 'initialize' stamp: 'jdm 12/6/2022 20:45:39'!
initialize
	"Que el colaborador permisos sea un set vacio, representa la falta de permisos, es decir, es privado"
	elementos _ OrderedCollection new.
	permisos _ Set new.
	usuariosCompartidos _ Set new.
	! !

!Directorio methodsFor: 'initialize' stamp: 'jdm 12/3/2022 00:19:04'!
initializeConNombre: unNombreDeElemento conDueño: unUsuario conFecha: unaFecha  

	nombre := unNombreDeElemento.
	dueño := unUsuario.
	fechaDeCreacion := unaFecha.! !


!Directorio methodsFor: 'actions' stamp: 'jdm 12/4/2022 01:48:40'!
borrarElemento: unNombreDeElemento 
	
	elementos remove: (self darElementoConNombre: unNombreDeElemento).! !

!Directorio methodsFor: 'actions' stamp: 'jdm 12/4/2022 17:02:06'!
cambiarPermisoDe: unPermiso alElemento: unElemento 
	(self darElementoConNombre: unElemento) cambiarPermisoDe: unPermiso.! !

!Directorio methodsFor: 'actions' stamp: 'jdm 12/6/2022 20:58:52'!
compartirElemento: unNombreDeElemento conUsuario: unUsuario 
	
	(self darElementoConNombre: unNombreDeElemento) agregarAUsuariosCompartidosElUsuario: unUsuario.! !

!Directorio methodsFor: 'actions' stamp: 'jdm 12/3/2022 01:08:51'!
crearArchivo: unNombreDeArchivo conDueño: unUsuario conFecha: unaFecha 
	(self estadoDelElementoConNombre: unNombreDeArchivo) crearArchivoPara: self conNombre: unNombreDeArchivo conDueño: unUsuario conFecha: unaFecha.! !

!Directorio methodsFor: 'actions' stamp: 'jdm 12/3/2022 01:26:28'!
crearArchivoConElNombreExistente: unNombreDeArchivo conDueño: unUsuario conFecha: unaFecha  
	self error: 'Ya existe un archivo con ese nombre'.! !

!Directorio methodsFor: 'actions' stamp: 'jdm 12/3/2022 02:01:29'!
crearArchivoConElNombreInexistente: unNombreDeArchivo conDueño: unUsuario conFecha: unaFecha  
	elementos add: (Archivo conNombre: unNombreDeArchivo conDueño: unUsuario conFecha: unaFecha).! !

!Directorio methodsFor: 'actions' stamp: 'jdm 12/3/2022 00:23:58'!
crearDirectorio: unNombreDeDirectorio conDueño: unUsuario conFecha: unaFecha 
	(self estadoDelElementoConNombre: unNombreDeDirectorio) crearDirectorioPara: self conNombre: unNombreDeDirectorio conDueño: unUsuario conFecha: unaFecha.! !

!Directorio methodsFor: 'actions' stamp: 'jdm 12/3/2022 00:33:32'!
crearDirectorioConElNombreExistente: unNombreDeDirectorio conDueño: unNombreDeUsuario conFecha: unaFecha
	
	self error: 'Ya existe un directorio con ese nombre'.! !

!Directorio methodsFor: 'actions' stamp: 'jdm 12/3/2022 02:00:56'!
crearDirectorioConElNombreInexistente: unNombreDeDirectorio conDueño: unNombreDeUsuario conFecha: unaFecha 
	
	elementos add: (Directorio conNombre: unNombreDeDirectorio conDueño: unNombreDeUsuario conFecha: unaFecha).! !

!Directorio methodsFor: 'actions' stamp: 'jdm 12/3/2022 01:01:38'!
darElementoConNombre: unNombreDeElemento
	^elementos detect:[: unElemento | unElemento tieneElNombre: unNombreDeElemento] ifNone: [self error: 'No existe el elemento buscado'].! !

!Directorio methodsFor: 'actions' stamp: 'jdm 12/4/2022 02:29:36'!
escribir: unContenidoDeTexto
	
	self error: 'No podes realizar esa accion sobre un directorio'.! !

!Directorio methodsFor: 'actions' stamp: 'jdm 12/4/2022 02:21:54'!
escribir: unContenidoDeTexto en: unNombreDeElemento 
	
	(self darElementoConNombre: unNombreDeElemento) escribir: unContenidoDeTexto.! !

!Directorio methodsFor: 'actions' stamp: 'jdm 12/6/2022 21:50:35'!
guardarResultadoEnDiscoDuro
	
	(nombre , '.txt') asFileEntry forceWriteStreamDo: [: aStream | aStream nextPutAll: 'Usuario:' , dueño ,  String newLineString.]! !

!Directorio methodsFor: 'actions' stamp: 'jdm 12/8/2022 00:47:47'!
guardarResultadoEnDiscoDuroPara: unSistemaMiniMiUNQ
	
	(nombre , '.txt') asFileEntry forceWriteStreamDo: [: unStream | unStream nextPutAll: ('Usuario:' , dueño nombre) ,  
			String newLineString.			
			  unSistemaMiniMiUNQ ruta do:[:unElemento | unStream 
											nextPutAll: unElemento nombre , '/']. String newLineString.
									unStream nextPutAll: ':', (elementos size asString); tab; nextPutAll: 'elementos', String newLineString.
										
			 			elementos do: [: unElemento | unStream 
											tab;
											nextPutAll: unElemento nombre; 
											tab;
											nextPutAll: unElemento fechaDeCreacionComoString;
											tab;
											nextPutAll: unElemento printUsuariosCompartidos,
											String newLineString.]]
			! !

!Directorio methodsFor: 'actions' stamp: 'jdm 12/4/2022 02:11:13'!
leerTextoDe: unNombreDeArchivo
	
	^ (self darElementoConNombre: unNombreDeArchivo) contenido.! !


!Directorio methodsFor: 'accessing' stamp: 'jdm 12/5/2022 22:51:36'!
archivosDelDirectorioActual
	
	^ elementos select: [: elemento | elemento esArchivo].! !

!Directorio methodsFor: 'accessing' stamp: 'jdm 12/2/2022 23:59:06'!
cantidadDeElementos
	^ elementos size.! !

!Directorio methodsFor: 'accessing' stamp: 'jdm 12/4/2022 02:32:27'!
contenido
	self error: 'No podes realizar esa accion sobre un directorio'.! !

!Directorio methodsFor: 'accessing' stamp: 'jdm 12/5/2022 22:52:49'!
elementosDelDirectorioActual
	^ elementos collect: [: elemento | elemento nombre].! !

!Directorio methodsFor: 'accessing' stamp: 'jdm 12/3/2022 01:59:58'!
estadoDelElementoConNombre: unNombreDeElemento 
	"Provee el estado del elemento recibido como colaborador externo. El estado del elemento indica como actuar de acuerdo a si ya existe un elemento con este nombre o no"

	^ EstadoDeElemento proveerEstadoDelElemento: unNombreDeElemento para: self.! !


!Directorio methodsFor: 'testing' stamp: 'jdm 12/5/2022 22:49:35'!
esArchivo
	^false! !

!Directorio methodsFor: 'testing' stamp: 'jdm 12/3/2022 00:59:29'!
esDirectorio
	^true.! !

!Directorio methodsFor: 'testing' stamp: 'jdm 12/2/2022 23:45:37'!
poseeUnElementoConNombre: unNombreDeElemento 
	^ self elementosDelDirectorioActual includes: unNombreDeElemento.! !


!classDefinition: #EstadoDeElemento category: 'tpFinalGrupo3'!
Object subclass: #EstadoDeElemento
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'tpFinalGrupo3'!

!EstadoDeElemento methodsFor: 'actions' stamp: 'jdm 12/3/2022 00:36:16'!
crearDirectorioPara: unDirectorio conNombre: unNombreDeDirectorio conDueño: unNombreDeUsuario conFecha: unaFecha 
	
	self subclassResponsibility.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'EstadoDeElemento class' category: 'tpFinalGrupo3'!
EstadoDeElemento class
	instanceVariableNames: ''!

!EstadoDeElemento class methodsFor: 'actions' stamp: 'jdm 12/2/2022 23:31:59'!
proveerEstadoDelElemento: unNombreDeElemento para: unDirectorio

	^ (self allSubclasses detect: [:unEstadoDeElemento | unEstadoDeElemento puedeHacerseCargoDe: unDirectorio con: unNombreDeElemento]) new.! !


!classDefinition: #EstadoDeElementoExistente category: 'tpFinalGrupo3'!
EstadoDeElemento subclass: #EstadoDeElementoExistente
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'tpFinalGrupo3'!

!EstadoDeElementoExistente methodsFor: 'actions' stamp: 'jdm 12/3/2022 01:25:13'!
crearArchivoPara: unDirectorio conNombre: unNombreDeArchivo conDueño: unNombreDeUsuario conFecha: unaFecha 

	unDirectorio crearArchivoConElNombreExistente: unNombreDeArchivo conDueño: unNombreDeUsuario conFecha: unaFecha.! !

!EstadoDeElementoExistente methodsFor: 'actions' stamp: 'jdm 12/3/2022 00:37:26'!
crearDirectorioPara: unDirectorio conNombre: unNombreDeDirectorio conDueño: unNombreDeUsuario conFecha: unaFecha 

	unDirectorio crearDirectorioConElNombreExistente: unNombreDeDirectorio conDueño: unNombreDeUsuario conFecha: unaFecha! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'EstadoDeElementoExistente class' category: 'tpFinalGrupo3'!
EstadoDeElementoExistente class
	instanceVariableNames: ''!

!EstadoDeElementoExistente class methodsFor: 'testing' stamp: 'jdm 12/2/2022 23:39:46'!
puedeHacerseCargoDe: unDirectorio con: unNombreDeElemento 
	^ unDirectorio poseeUnElementoConNombre: unNombreDeElemento 
	! !


!classDefinition: #EstadoDeElementoInexistente category: 'tpFinalGrupo3'!
EstadoDeElemento subclass: #EstadoDeElementoInexistente
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'tpFinalGrupo3'!

!EstadoDeElementoInexistente methodsFor: 'actions' stamp: 'jdm 12/3/2022 02:01:29'!
crearArchivoPara: unDirectorio conNombre: unNombreDeArchivo conDueño: unNombreDeUsuario conFecha: unaFecha 

	unDirectorio crearArchivoConElNombreInexistente: unNombreDeArchivo conDueño: unNombreDeUsuario conFecha: unaFecha.! !

!EstadoDeElementoInexistente methodsFor: 'actions' stamp: 'jdm 12/3/2022 02:00:56'!
crearDirectorioPara: unDirectorio conNombre: unNombreDeDirectorio conDueño: unNombreDeUsuario conFecha: unaFecha  
	
	unDirectorio crearDirectorioConElNombreInexistente:  unNombreDeDirectorio conDueño: unNombreDeUsuario conFecha: unaFecha.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'EstadoDeElementoInexistente class' category: 'tpFinalGrupo3'!
EstadoDeElementoInexistente class
	instanceVariableNames: ''!

!EstadoDeElementoInexistente class methodsFor: 'testing' stamp: 'jdm 12/2/2022 23:47:16'!
puedeHacerseCargoDe: unDirectorio con: unNombreDeElemento
	
	^ (unDirectorio poseeUnElementoConNombre: unNombreDeElemento) not.! !


!classDefinition: #EstadoDeRuta category: 'tpFinalGrupo3'!
Object subclass: #EstadoDeRuta
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'tpFinalGrupo3'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'EstadoDeRuta class' category: 'tpFinalGrupo3'!
EstadoDeRuta class
	instanceVariableNames: ''!

!EstadoDeRuta class methodsFor: 'actions' stamp: 'jdm 12/3/2022 01:44:26'!
darEstadoDeRutaPara: unSistemaMiniMiUNQ 

	^ (self allSubclasses detect: [: unEstadoDeRuta | unEstadoDeRuta puedeHacerseCargoDe: unSistemaMiniMiUNQ]) new.! !


!classDefinition: #EstadoDeRutaEnDirectorioNoRaiz category: 'tpFinalGrupo3'!
EstadoDeRuta subclass: #EstadoDeRutaEnDirectorioNoRaiz
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'tpFinalGrupo3'!

!EstadoDeRutaEnDirectorioNoRaiz methodsFor: 'actions' stamp: 'jdm 12/3/2022 01:56:46'!
volverADirectorioPadrePara: unSistemaMiniMiUNQ 
	
	unSistemaMiniMiUNQ  volverAlDirectorioPadreParaDirectorioNoRaiz. ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'EstadoDeRutaEnDirectorioNoRaiz class' category: 'tpFinalGrupo3'!
EstadoDeRutaEnDirectorioNoRaiz class
	instanceVariableNames: ''!

!EstadoDeRutaEnDirectorioNoRaiz class methodsFor: 'actions' stamp: 'jdm 12/3/2022 01:48:40'!
puedeHacerseCargoDe: unSistemaMiniMiUNQ 
	
	^ (unSistemaMiniMiUNQ seEncuentraEnDirectorioRaiz) not.! !


!classDefinition: #EstadoDeRutaEnDirectorioRaiz category: 'tpFinalGrupo3'!
EstadoDeRuta subclass: #EstadoDeRutaEnDirectorioRaiz
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'tpFinalGrupo3'!

!EstadoDeRutaEnDirectorioRaiz methodsFor: 'actions' stamp: 'jdm 12/3/2022 01:55:35'!
volverADirectorioPadrePara: unSistemaMiniMiUNQ 
	
	unSistemaMiniMiUNQ volverADirectorioPadreParaDirectorioRaiz.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'EstadoDeRutaEnDirectorioRaiz class' category: 'tpFinalGrupo3'!
EstadoDeRutaEnDirectorioRaiz class
	instanceVariableNames: ''!

!EstadoDeRutaEnDirectorioRaiz class methodsFor: 'as yet unclassified' stamp: 'jdm 12/3/2022 01:47:55'!
puedeHacerseCargoDe: unSistemaMiniMiUNQ 
	
	^ unSistemaMiniMiUNQ seEncuentraEnDirectorioRaiz.! !


!classDefinition: #EstadoDeUsuario category: 'tpFinalGrupo3'!
Object subclass: #EstadoDeUsuario
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'tpFinalGrupo3'!

!EstadoDeUsuario methodsFor: 'actions' stamp: 'jdm 12/1/2022 22:22:53'!
realizarBajaEn: unSistemaMiniMiUNQ de: unUsuario 
	
	self subclassResponsibility.! !

!EstadoDeUsuario methodsFor: 'actions' stamp: 'jdm 12/1/2022 16:19:30'!
realizarRegistroEn: unSistemaMiniMiUNQ de: unUsuario 
	self subclassResponsibility.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'EstadoDeUsuario class' category: 'tpFinalGrupo3'!
EstadoDeUsuario class
	instanceVariableNames: ''!

!EstadoDeUsuario class methodsFor: 'instance creation' stamp: 'jdm 12/1/2022 16:14:18'!
para: unUsuario en: unSistemaMiniMiUNQ 

	^ (self subclasses detect: [: unEstadoDeUsuario | unEstadoDeUsuario puedeHacerseCargoDe: unUsuario en: unSistemaMiniMiUNQ]) new.! !

!EstadoDeUsuario class methodsFor: 'instance creation' stamp: 'jdm 12/1/2022 16:15:46'!
puedeHacerseCargoDe: unUsuario en: unSistemaMiniMiUNQ

	self subclassResponsibility.! !


!classDefinition: #EstadoDeUsuarioNoRegistrado category: 'tpFinalGrupo3'!
EstadoDeUsuario subclass: #EstadoDeUsuarioNoRegistrado
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'tpFinalGrupo3'!

!EstadoDeUsuarioNoRegistrado methodsFor: 'as yet unclassified' stamp: 'jdm 12/1/2022 22:22:35'!
realizarBajaEn: unSistemaMiniMiUNQ de: unUsuario 
	
	unSistemaMiniMiUNQ realizarBajaInvalidaDe: unUsuario.! !

!EstadoDeUsuarioNoRegistrado methodsFor: 'as yet unclassified' stamp: 'jdm 12/1/2022 23:06:40'!
realizarModificacionEn: unSistemaMiniMiUNQ de: unUsuario conNuevoNombreDeUsuario: unNombreDeUsuario conNuevaContraseña: unaContraseña 
	
	unSistemaMiniMiUNQ realizarModificacionInvalidaDe: unUsuario conNuevoNombreDeUsuario: unNombreDeUsuario conNuevaContraseña: unaContraseña.! !

!EstadoDeUsuarioNoRegistrado methodsFor: 'as yet unclassified' stamp: 'jdm 12/1/2022 16:20:52'!
realizarRegistroEn: unSistemaMiniMiUNQ de: unUsuario 

	unSistemaMiniMiUNQ realizarRegistroValidoDe: unUsuario.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'EstadoDeUsuarioNoRegistrado class' category: 'tpFinalGrupo3'!
EstadoDeUsuarioNoRegistrado class
	instanceVariableNames: ''!

!EstadoDeUsuarioNoRegistrado class methodsFor: 'as yet unclassified' stamp: 'jdm 12/1/2022 22:08:11'!
puedeHacerseCargoDe: unUsuario en: unSistemaMiniMiUNQ

	^ ((unSistemaMiniMiUNQ tieneRegistradoA: unUsuario) not) & (unUsuario esRoot not).! !


!classDefinition: #EstadoDeUsuarioRegistrado category: 'tpFinalGrupo3'!
EstadoDeUsuario subclass: #EstadoDeUsuarioRegistrado
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'tpFinalGrupo3'!

!EstadoDeUsuarioRegistrado methodsFor: 'as yet unclassified' stamp: 'jdm 12/1/2022 23:49:00'!
elUsuarioActualEsAdministradorDe: unSistemaMiniMiUNQ 

	^ unSistemaMiniMiUNQ usuarioActual esAdministrador.
	! !

!EstadoDeUsuarioRegistrado methodsFor: 'as yet unclassified' stamp: 'jdm 12/1/2022 23:51:43'!
esAdministradorORoot: unUsuario

	^ (unUsuario esAdministrador | unUsuario esRoot).! !

!EstadoDeUsuarioRegistrado methodsFor: 'as yet unclassified' stamp: 'jdm 12/1/2022 16:21:00'!
realizarRegistroEn: unSistemaMiniMiUNQ de: unUsuario 

	unSistemaMiniMiUNQ realizarRegistroInvalidoDe: unUsuario.! !


!EstadoDeUsuarioRegistrado methodsFor: 'actions' stamp: 'jdm 12/4/2022 14:21:24'!
realizarBajaEn: unSistemaMiniMiUNQ de: unUsuario 
	
	(unSistemaMiniMiUNQ usuarioActual esRoot) 
	ifTrue: [unSistemaMiniMiUNQ realizarBajaValidaDe: unUsuario]
	ifFalse: [unSistemaMiniMiUNQ error: 'No tenes los permisos suficientes para realizar esta accion'].! !

!EstadoDeUsuarioRegistrado methodsFor: 'actions' stamp: 'jdm 12/1/2022 23:52:40'!
realizarModificacionEn: unSistemaMiniMiUNQ de: unUsuario conNuevoNombreDeUsuario: unNombreDeUsuario conNuevaContraseña: unaContraseña 

	((self elUsuarioActualEsAdministradorDe: unSistemaMiniMiUNQ) & (self esAdministradorORoot: unUsuario)) 
	ifTrue: [unSistemaMiniMiUNQ realizarModificacionInvalidaDe: unUsuario conNuevoNombreDeUsuario: unNombreDeUsuario conNuevaContraseña: unaContraseña] 
	ifFalse: [unSistemaMiniMiUNQ realizarModificacionValidaDe: unUsuario conNuevoNombreDeUsuario: unNombreDeUsuario conNuevaContraseña: unaContraseña].
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'EstadoDeUsuarioRegistrado class' category: 'tpFinalGrupo3'!
EstadoDeUsuarioRegistrado class
	instanceVariableNames: ''!

!EstadoDeUsuarioRegistrado class methodsFor: 'as yet unclassified' stamp: 'jdm 12/1/2022 16:23:18'!
puedeHacerseCargoDe: unUsuario en: unSistemaMiniMiUNQ

	^ ((unSistemaMiniMiUNQ tieneRegistradoA: unUsuario) | (unUsuario esRoot)).! !


!classDefinition: #Filtro category: 'tpFinalGrupo3'!
Object subclass: #Filtro
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'tpFinalGrupo3'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Filtro class' category: 'tpFinalGrupo3'!
Filtro class
	instanceVariableNames: ''!


!Filtro class methodsFor: 'actions' stamp: 'jdm 12/5/2022 23:18:57'!
filtrarPorContenidoDeTexto: unContenidoDeTexto de: unaColeccionDeArchivos 
	^ unaColeccionDeArchivos select: [: unArchivo | unArchivo contenido includesSubString: unContenidoDeTexto].! !


!classDefinition: #FiltroPorContenidoDeTexto category: 'tpFinalGrupo3'!
Filtro subclass: #FiltroPorContenidoDeTexto
	instanceVariableNames: 'contenidoDeTexto'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'tpFinalGrupo3'!

!FiltroPorContenidoDeTexto methodsFor: 'initialize' stamp: 'jdm 12/5/2022 23:51:24'!
initializeConContenidoDeTexto: unContenidoDeTexto 

	contenidoDeTexto := unContenidoDeTexto.! !


!FiltroPorContenidoDeTexto methodsFor: 'actions' stamp: 'jdm 12/5/2022 23:36:27'!
filtrarLosArchivos: unaColeccionDeArchivos 
	^ unaColeccionDeArchivos select: [:unArchivo | unArchivo contenido includesSubString: contenidoDeTexto].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'FiltroPorContenidoDeTexto class' category: 'tpFinalGrupo3'!
FiltroPorContenidoDeTexto class
	instanceVariableNames: ''!

!FiltroPorContenidoDeTexto class methodsFor: 'instance creation' stamp: 'jdm 12/5/2022 23:50:59'!
conContenidoDeTexto: unContenidoDeTexto 
	^self new initializeConContenidoDeTexto: unContenidoDeTexto.! !


!classDefinition: #FiltroPorDueño category: 'tpFinalGrupo3'!
Filtro subclass: #FiltroPorDueño
	instanceVariableNames: 'dueño'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'tpFinalGrupo3'!

!FiltroPorDueño methodsFor: 'initialize' stamp: 'jdm 12/5/2022 23:44:51'!
initializeConDueño: unUsuario 

	dueño := unUsuario.! !


!FiltroPorDueño methodsFor: 'actions' stamp: 'jdm 12/5/2022 23:46:04'!
filtrarLosArchivos: unaColeccionDeArchivos

	^ unaColeccionDeArchivos select: [:unArchivo | unArchivo dueño = dueño].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'FiltroPorDueño class' category: 'tpFinalGrupo3'!
FiltroPorDueño class
	instanceVariableNames: ''!

!FiltroPorDueño class methodsFor: 'instance creation' stamp: 'jdm 12/5/2022 23:44:13'!
conDueño: unUsuario 

	^self new initializeConDueño: unUsuario. ! !


!classDefinition: #FiltroPorFechaDeCreacion category: 'tpFinalGrupo3'!
Filtro subclass: #FiltroPorFechaDeCreacion
	instanceVariableNames: 'fechaDeCreacion'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'tpFinalGrupo3'!

!FiltroPorFechaDeCreacion methodsFor: 'initialize' stamp: 'jdm 12/5/2022 23:39:22'!
initializeConFechaDeCreacion: unaFecha 

	fechaDeCreacion := unaFecha.! !


!FiltroPorFechaDeCreacion methodsFor: 'actions' stamp: 'jdm 12/5/2022 23:46:14'!
filtrarLosArchivos: unaColeccionDeArchivos
	
	^ unaColeccionDeArchivos select: [:unArchivo | unArchivo fechaDeCreacion = fechaDeCreacion].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'FiltroPorFechaDeCreacion class' category: 'tpFinalGrupo3'!
FiltroPorFechaDeCreacion class
	instanceVariableNames: ''!

!FiltroPorFechaDeCreacion class methodsFor: 'instance creation' stamp: 'jdm 12/5/2022 23:38:53'!
conFechaDeCreacion: unaFecha 

	^self new initializeConFechaDeCreacion: unaFecha. ! !


!classDefinition: #FiltroPorPermisos category: 'tpFinalGrupo3'!
Filtro subclass: #FiltroPorPermisos
	instanceVariableNames: 'permiso'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'tpFinalGrupo3'!

!FiltroPorPermisos methodsFor: 'initialize' stamp: 'jdm 12/5/2022 23:47:35'!
initializeConPermisoDe: unPermiso 

	permiso := unPermiso.! !


!FiltroPorPermisos methodsFor: 'actions' stamp: 'jdm 12/5/2022 23:48:13'!
filtrarLosArchivos: unaColeccionDeArchivos 
	^ unaColeccionDeArchivos select: [:unArchivo | unArchivo permisos includes: permiso].! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'FiltroPorPermisos class' category: 'tpFinalGrupo3'!
FiltroPorPermisos class
	instanceVariableNames: ''!

!FiltroPorPermisos class methodsFor: 'instance creation' stamp: 'jdm 12/5/2022 23:47:19'!
conPermisoDe: unPermiso 

	^self new initializeConPermisoDe: unPermiso. ! !


!classDefinition: #LectorDeUsuarios category: 'tpFinalGrupo3'!
Object subclass: #LectorDeUsuarios
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'tpFinalGrupo3'!

!LectorDeUsuarios methodsFor: 'actions' stamp: 'jdm 12/8/2022 12:36:14'!
leer: unStream
	
	 | contenido |
	  contenido _ unStream contents.
	
	^contenido lines select: [: l | self esValida: l] thenCollect: [: l | (self leerDe: l)] ! !

!LectorDeUsuarios methodsFor: 'actions' stamp: 'jdm 12/8/2022 12:43:49'!
leerContraseñaDe: columnas
	^ columnas at: 2 asNumber.! !

!LectorDeUsuarios methodsFor: 'actions' stamp: 'jdm 12/8/2022 18:38:57'!
leerDe: unaLinea

	| columnas unNombreDeUsuario unaContraseña |
	columnas _ unaLinea findTokens: self delimitador. 

	unNombreDeUsuario _ self leerUsuarioDe: columnas.
	unaContraseña _ self leerContraseñaDe: columnas.
	
	^ UsuarioComun conNombreDeUsuario: unNombreDeUsuario conContraseña: unaContraseña.! !

!LectorDeUsuarios methodsFor: 'actions' stamp: 'jdm 12/8/2022 12:43:41'!
leerUsuarioDe: columnas
	^ columnas at: 1 asNumber.! !


!LectorDeUsuarios methodsFor: 'testing' stamp: 'jdm 12/8/2022 12:37:20'!
esValida: unaLinea 

	^ (self tieneLasColumnasCorrectas: unaLinea) and: [ self noEsCabecera: unaLinea ]! !

!LectorDeUsuarios methodsFor: 'testing' stamp: 'jdm 12/8/2022 12:45:07'!
noEsCabecera: unaLinea

	^ (unaLinea includesSubString: 'Usuario, Contraseña') not! !

!LectorDeUsuarios methodsFor: 'testing' stamp: 'jdm 12/8/2022 12:38:03'!
tieneLasColumnasCorrectas: unaLinea

	^ (unaLinea occurrencesOf: self delimitador) == self cantidadDeColumnas.! !


!LectorDeUsuarios methodsFor: 'accessing' stamp: 'jdm 12/8/2022 18:34:44'!
cantidadDeColumnas
	^ 1.! !

!LectorDeUsuarios methodsFor: 'accessing' stamp: 'jdm 12/8/2022 12:38:54'!
delimitador
	^ $,! !


!classDefinition: #MiniMiUNQ category: 'tpFinalGrupo3'!
Object subclass: #MiniMiUNQ
	instanceVariableNames: 'usuarioActual usuariosRegistrados ruta'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'tpFinalGrupo3'!

!MiniMiUNQ methodsFor: 'initialize' stamp: 'jdm 12/2/2022 15:05:08'!
initialize

	ruta _ OrderedCollection new.
	usuariosRegistrados _ Set new.
	! !

!MiniMiUNQ methodsFor: 'initialize' stamp: 'jdm 12/2/2022 15:10:06'!
initializeConUsuarioRoot: unUsuario conUsuarioPublico: otroUsuario conUsuarioActual: otroUsuarioMas conDirectorioRaiz: unDirectorio

	ruta add: unDirectorio.
	usuariosRegistrados add: unUsuario.
	usuariosRegistrados add: otroUsuario.
	usuarioActual := otroUsuarioMas.
	! !


!MiniMiUNQ methodsFor: 'accessing' stamp: 'jdm 12/5/2022 23:15:45'!
archivosDelDirectorioActual
	self shouldBeImplemented.! !

!MiniMiUNQ methodsFor: 'accessing' stamp: 'jdm 12/1/2022 14:14:12'!
cantidadDeUsuariosRegistrados

	^ usuariosRegistrados size.! !

!MiniMiUNQ methodsFor: 'accessing' stamp: 'jdm 12/2/2022 15:01:17'!
directorioActual
	^ self ultimoDirectorioDeLaRuta.! !

!MiniMiUNQ methodsFor: 'accessing' stamp: 'jdm 12/3/2022 01:59:20'!
estadoDeRutaEnBaseAlDirectorioRaiz
	
	^ EstadoDeRuta darEstadoDeRutaPara: self.! !

!MiniMiUNQ methodsFor: 'accessing' stamp: 'jdm 12/6/2022 21:57:25'!
ruta
	^ruta.! !

!MiniMiUNQ methodsFor: 'accessing' stamp: 'jdm 12/2/2022 15:01:31'!
ultimoDirectorioDeLaRuta
	^ ruta last.! !

!MiniMiUNQ methodsFor: 'accessing' stamp: 'jdm 12/1/2022 14:51:09'!
usuarioActual
	^usuarioActual.! !


!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/3/2022 00:54:44'!
accederADirectorio: unNombreDeDirectorio

	| directorioDestino |
	directorioDestino _ self directorioActual darElementoConNombre: unNombreDeDirectorio.
	
	self validarSiEsDirectorio: directorioDestino.
	
	ruta add: directorioDestino.! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/1/2022 16:13:41'!
agregarUsuario: unUsuario 
	
	| estado |
	estado _ EstadoDeUsuario para: unUsuario en: self.
	
	estado realizarRegistroEn: self de: unUsuario.! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/8/2022 18:39:45'!
agregarUsuariosComunesUsando: unArchivo 
	
	| usuarios |
	usuarios _ LectorDeUsuarios new leer: unArchivo fileContents.
	
	usuarios do:[: unUsuario | self agregarUsuario: unUsuario].! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/4/2022 18:25:55'!
borrarElementoConNombre: unNombreDeElemento
	
	self validarPermisoDeBorradoEn: unNombreDeElemento.
	self directorioActual borrarElemento: unNombreDeElemento.
	! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/4/2022 16:58:36'!
cambiarPermisoDe: unPermiso alElemento: unElemento 
	self validarSiElUsuarioPuedeCambiarPermisosDe: unElemento.
	self directorioActual cambiarPermisoDe: unPermiso alElemento: unElemento.! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/6/2022 20:22:31'!
compartirElemento: unNombreDeElemento conUsuario: unUsuario 

	self directorioActual compartirElemento: unNombreDeElemento conUsuario: unUsuario.! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/8/2022 00:57:05'!
crearArchivoConNombre: unNombreDeArchivo 
	
	self directorioActual crearArchivo: unNombreDeArchivo conDueño: self usuarioActual conFecha: FixedGregorianDate today.! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/4/2022 03:47:37'!
crearDirectorioConNombre: unNombreDelDirectorio
	
	self validarPermisoDeEscrituraEnDirectorioActual.
	self directorioActual crearDirectorio: unNombreDelDirectorio conDueño: self usuarioActual conFecha: FixedGregorianDate today.! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/1/2022 22:20:17'!
darDeBajaA: unUsuario 
	
	| estado |
	estado _ EstadoDeUsuario para: unUsuario en: self.
	
	estado realizarBajaEn: self de: unUsuario.! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/4/2022 18:20:57'!
escribir: unContenidoDeTexto en: unNombreDeArchivo
	
	self validarPermisoDeEscrituraEn: unNombreDeArchivo.
	self directorioActual escribir: unContenidoDeTexto en: unNombreDeArchivo.	! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/5/2022 22:53:26'!
filtrarArchivosEnDirectorioActualPorContenidoDeTexto: unContenidoDeTexto 
	
	^ self directorioActual archivosDelDirectorioActual select:[: unArchivo | unArchivo contenido includesSubString: unContenidoDeTexto].! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/5/2022 22:50:41'!
filtrarArchivosEnDirectorioActualPorDueño: unUsuario
	
	^ self directorioActual archivosDelDirectorioActual select:[: unArchivo | unArchivo dueño = unUsuario].! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/5/2022 22:53:16'!
filtrarArchivosEnDirectorioActualPorFechaDeCreacion: unaFecha 
	
	^ self directorioActual archivosDelDirectorioActual select:[: unArchivo | unArchivo fechaDeCreacion isEqualTo: unaFecha].! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/5/2022 22:58:59'!
filtrarArchivosEnDirectorioActualQueTenganPermisoDe: unPermiso
	
	^ self directorioActual archivosDelDirectorioActual select:[: unArchivo | unArchivo tienePermisoDe: unPermiso].! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/5/2022 23:34:07'!
filtrarPor: unaColeccionDeFiltros 
	
	| archivosAFiltrar |
	archivosAFiltrar _ self directorioActual archivosDelDirectorioActual .
	
	unaColeccionDeFiltros do: [: unTipoDeFiltro | archivosAFiltrar _ unTipoDeFiltro filtrarLosArchivos: archivosAFiltrar].
	
	^ archivosAFiltrar.! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/6/2022 21:51:56'!
guardarResultadoEnDiscoDuro
	
	self directorioActual guardarResultadoEnDiscoDuroPara: self.! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/1/2022 14:58:49'!
iniciarSesionConNombreDeUsuario: unNombreDeUsuario yContraseña: unaContraseña 

	^ usuariosRegistrados detect:[: unUsuario | unUsuario coincideConNombreDeUsuario: unNombreDeUsuario yContraseña: unaContraseña  ] 
					     ifFound: [: unUsuario |  usuarioActual _ unUsuario]
					     ifNone: [ self error: 'Nombre de usuario o contraseña invalida' ].! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/4/2022 02:08:06'!
leerTextoDe: unNombreDeElemento 
	
	^ self directorioActual leerTextoDe: unNombreDeElemento.! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/4/2022 18:12:45'!
leerTextoDeArchivo: unNombreDeElemento 
	
	self validarPermisoDeLecturaEn: unNombreDeElemento.
	^ self directorioActual leerTextoDeArchivo: unNombreDeElemento.! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/1/2022 23:32:06'!
modificarUsuario: unUsuario conNuevoNombreDeUsuario: unNombreDeUsuario conNuevaContraseña: unaContraseña 
	
	| estado |
	estado _ EstadoDeUsuario para: unUsuario en: self.
	
	estado realizarModificacionEn: self de: unUsuario conNuevoNombreDeUsuario: unNombreDeUsuario conNuevaContraseña: unaContraseña.! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/1/2022 22:33:34'!
realizarBajaInvalidaDe: unUsuario 
	
	^ self error: 'El usuario que quiere dar de baja no esta registrado'.! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/1/2022 22:23:38'!
realizarBajaValidaDe: unUsuario
	
	usuariosRegistrados remove: unUsuario.! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/1/2022 23:19:58'!
realizarModificacionInvalidaDe: unUsuario conNuevoNombreDeUsuario: unNombreDeUsuario conNuevaContraseña: unaContraseña
	
	^ self error: 'No tenes los permisos suficientes para realizar esta accion o el usuario que deseas modificar no esta registrado'! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/1/2022 23:04:44'!
realizarModificacionValidaDe: unUsuario conNuevoNombreDeUsuario: unNombreDeUsuario conNuevaContraseña: unaContraseña
	
	unUsuario modificarConNuevoNombre: unNombreDeUsuario conNuevaContraseña: unaContraseña.! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/1/2022 16:24:56'!
realizarRegistroInvalidoDe: unUsuario 
	^ self error: 'El usuario que quiere añadir ya existe o es un usuario root'.! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/1/2022 16:21:36'!
realizarRegistroValidoDe: unUsuario
	usuariosRegistrados add: unUsuario.! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/4/2022 18:27:10'!
validarPermisoDeBorradoEn: unNombreDeElemento 
	(self tienePermisoDeBorradoEn: unNombreDeElemento ) ifFalse: [self error: 'No tenes permisos suficientes para realizar esta accion'].! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/4/2022 18:22:37'!
validarPermisoDeEscrituraEn: unNombreDeArchivo
	
	(self tienePermisoDeEscrituraEn: unNombreDeArchivo) ifFalse: [self error: 'No tenes permisos suficientes para realizar esta accion' ]! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/3/2022 00:34:30'!
validarPermisoDeEscrituraEnDirectorioActual
	self tienePermisoDeEscrituraEnElDirectorioActual 
	ifFalse: [ self error: 'No tenes permisos suficientes para realizar esta accion' ].! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/4/2022 18:15:08'!
validarPermisoDeLecturaEn: unNombreDeElemento 
	
	(self tienePermisoDeLecturaEn: unNombreDeElemento) ifFalse: [self error: 'No tenes permisos suficientes para realizar esta accion'].
! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/4/2022 17:00:51'!
validarSiElUsuarioPuedeCambiarPermisosDe: unElemento 
	((self elUsuarioActualEsElDueñoDe: unElemento) | self elUsuarioActualEsRoot ) ifFalse: [self error: 'No tenes los permisos suficientes para realizar esta accion'] ! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/3/2022 00:58:57'!
validarSiEsDirectorio: unElemento 
	unElemento esDirectorio ifFalse: [self error: 'No se puede realizar esta acción sobre un archivo'].! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/3/2022 01:42:30'!
volverADirectorioPadre
	
	(self estadoDeRutaEnBaseAlDirectorioRaiz) volverADirectorioPadrePara: self.
! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/3/2022 01:56:03'!
volverADirectorioPadreParaDirectorioRaiz
	
	self error: 'Estas en el directorio raiz'.! !

!MiniMiUNQ methodsFor: 'actions' stamp: 'jdm 12/3/2022 01:56:46'!
volverAlDirectorioPadreParaDirectorioNoRaiz
	ruta removeLast.! !


!MiniMiUNQ methodsFor: 'testing' stamp: 'jdm 12/4/2022 02:38:14'!
elUsuarioActualEsElDueñoDe: unNombreDeElemento
	
	^ self directorioActual elElemento: unNombreDeElemento tieneComoDueñoA: usuarioActual. ! !

!MiniMiUNQ methodsFor: 'testing' stamp: 'jdm 12/4/2022 03:03:09'!
elUsuarioActualEsRoot
	^ usuarioActual esRoot.! !

!MiniMiUNQ methodsFor: 'testing' stamp: 'jdm 12/3/2022 01:48:08'!
seEncuentraEnDirectorioRaiz
	^ ruta size = 1.! !

!MiniMiUNQ methodsFor: 'testing' stamp: 'jdm 12/4/2022 03:35:38'!
tienePermisoDeBorradoEn: unNombreDeElemento
	
	^ self elUsuarioActualEsRoot | (self elUsuarioActualEsElDueñoDe: unNombreDeElemento) | (self directorioActual permisoDeBorradoDelElemento: unNombreDeElemento).! !

!MiniMiUNQ methodsFor: 'testing' stamp: 'jdm 12/4/2022 03:15:15'!
tienePermisoDeEscrituraEn: unNombreDeElemento

	^ self elUsuarioActualEsRoot | (self elUsuarioActualEsElDueñoDe: unNombreDeElemento) | (self directorioActual permisoDeEscrituraDelElemento: unNombreDeElemento).! !

!MiniMiUNQ methodsFor: 'testing' stamp: 'jdm 12/4/2022 13:59:42'!
tienePermisoDeEscrituraEnElDirectorioActual
	^ self elUsuarioActualEsRoot | (self directorioActual tieneComoDueñoA: usuarioActual) | (self directorioActual = ruta first).! !

!MiniMiUNQ methodsFor: 'testing' stamp: 'jdm 12/4/2022 03:03:29'!
tienePermisoDeLecturaEn: unNombreDeElemento 
	
	^ self elUsuarioActualEsRoot | (self elUsuarioActualEsElDueñoDe: unNombreDeElemento) | (self directorioActual permisoDeLecturaDelElemento: unNombreDeElemento).! !

!MiniMiUNQ methodsFor: 'testing' stamp: 'jdm 12/1/2022 16:18:31'!
tieneRegistradoA: unUsuario
	
	^ usuariosRegistrados includes: unUsuario.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MiniMiUNQ class' category: 'tpFinalGrupo3'!
MiniMiUNQ class
	instanceVariableNames: ''!

!MiniMiUNQ class methodsFor: 'instance creation' stamp: 'jdm 12/2/2022 15:10:23'!
conUsuarioRoot: unUsuario conUsuarioPublico: otroUsuario conUsuarioActual: otroUsuarioMas conDirectorioRaiz: unDirectorio
	^self new initializeConUsuarioRoot: unUsuario conUsuarioPublico: otroUsuario conUsuarioActual: otroUsuarioMas conDirectorioRaiz: unDirectorio.

	! !


!classDefinition: #RegistradorDeUsuarios category: 'tpFinalGrupo3'!
Object subclass: #RegistradorDeUsuarios
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'tpFinalGrupo3'!

!RegistradorDeUsuarios methodsFor: 'actions' stamp: 'jdm 12/8/2022 12:30:21'!
delimitador
	
	^ ','! !

!RegistradorDeUsuarios methodsFor: 'actions' stamp: 'jdm 12/8/2022 12:15:49'!
escribirEn: unArchivo losUsuarios: usuarios
	
	unArchivo forceWriteStreamDo: [:unStream | 		
		unStream nextPutAll: 'Usuario, Contraseña'.
		usuarios do: [: unUsuario | 
			unStream newLine.
			unStream nextPutAll: (self infoDeUsuario: unUsuario). 
		].
	].! !

!RegistradorDeUsuarios methodsFor: 'actions' stamp: 'jdm 12/8/2022 12:18:31'!
infoDeUsuario: unUsuario

	^ unUsuario nombre , self delimitador, 
	  unUsuario contraseña , self delimitador.! !


!classDefinition: #Usuario category: 'tpFinalGrupo3'!
Object subclass: #Usuario
	instanceVariableNames: 'nombre contraseña'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'tpFinalGrupo3'!

!Usuario methodsFor: 'initialize' stamp: 'jdm 12/1/2022 14:30:02'!
initializeConNombreDeUsuario: unNombreDeUsuario conContraseña: unaContraseña
	nombre _ unNombreDeUsuario.
	contraseña _ unaContraseña.! !


!Usuario methodsFor: 'testing' stamp: 'jdm 12/1/2022 14:59:28'!
coincideConNombreDeUsuario: unNombreDeUsuario yContraseña: unaContraseña 

	 ^ (nombre = unNombreDeUsuario) & (contraseña = unaContraseña).! !

!Usuario methodsFor: 'testing' stamp: 'jdm 12/2/2022 00:31:34'!
esAdministrador
	self subclassResponsibility.! !

!Usuario methodsFor: 'testing' stamp: 'jdm 12/2/2022 00:31:51'!
esRoot
	self subclassResponsibility.! !

!Usuario methodsFor: 'testing' stamp: 'jdm 12/2/2022 00:32:06'!
noEsRoot
	self subclassResponsibility.! !


!Usuario methodsFor: 'actions' stamp: 'jdm 12/1/2022 22:41:30'!
modificarConNuevoNombre: unNombreDeUsuario conNuevaContraseña: unaContraseña 
	
	nombre _ unNombreDeUsuario.
	contraseña _ unaContraseña.! !


!Usuario methodsFor: 'accessing' stamp: 'jdm 12/1/2022 22:41:52'!
contraseña
	^contraseña! !

!Usuario methodsFor: 'accessing' stamp: 'jdm 12/1/2022 22:41:46'!
nombre
	^nombre! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Usuario class' category: 'tpFinalGrupo3'!
Usuario class
	instanceVariableNames: ''!

!Usuario class methodsFor: 'instance creation' stamp: 'jdm 12/1/2022 14:24:13'!
conNombreDeUsuario: unNombreDeUsuario conContraseña: unaContraseña
	^self new initializeConNombreDeUsuario: unNombreDeUsuario conContraseña: unaContraseña.

	! !


!classDefinition: #UsuarioAdministrador category: 'tpFinalGrupo3'!
Usuario subclass: #UsuarioAdministrador
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'tpFinalGrupo3'!

!UsuarioAdministrador methodsFor: 'testing' stamp: 'jdm 12/1/2022 23:32:26'!
esAdministrador
	^true.! !

!UsuarioAdministrador methodsFor: 'testing' stamp: 'jdm 12/2/2022 00:31:39'!
esRoot
	^false.! !


!classDefinition: #UsuarioComun category: 'tpFinalGrupo3'!
Usuario subclass: #UsuarioComun
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'tpFinalGrupo3'!

!UsuarioComun methodsFor: 'testing' stamp: 'jdm 12/1/2022 23:53:07'!
esAdministrador
	^false.! !

!UsuarioComun methodsFor: 'testing' stamp: 'jdm 12/1/2022 15:22:06'!
esRoot

	^false.! !


!classDefinition: #UsuarioPublico category: 'tpFinalGrupo3'!
Usuario subclass: #UsuarioPublico
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'tpFinalGrupo3'!

!UsuarioPublico methodsFor: 'as yet unclassified' stamp: 'jdm 12/4/2022 16:08:29'!
esAdministrador
	^false.! !

!UsuarioPublico methodsFor: 'as yet unclassified' stamp: 'jdm 12/4/2022 13:52:03'!
esRoot

	^false.! !


!classDefinition: #UsuarioRoot category: 'tpFinalGrupo3'!
Usuario subclass: #UsuarioRoot
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'tpFinalGrupo3'!

!UsuarioRoot methodsFor: 'testing' stamp: 'jdm 12/1/2022 23:38:22'!
esAdministrador
	^false.! !

!UsuarioRoot methodsFor: 'testing' stamp: 'jdm 12/1/2022 15:21:47'!
esRoot

	^true.! !
