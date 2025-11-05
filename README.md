<a name="inicio"></a>
# Resto Apertura Comandas (Mostrador y Delivery) y funciones automáticas

La API permite registrar en la base de datos de Tango Restó, las comandas o pedidos generados por aplicaciones externas. Esta información es recibida como parámetros de entrada y la comanda será visualizada en el módulo de Delivery o Mostrador según sea el caso.
También dispone de una funcionalidad automática para enviar a cocina artículos de una comanda y de facturar automáticamente luego del envío a cocina. 

Desde Restô se podrá:
  - Identificar el origen de la comanda. 
  - Cancelar una comanda.
  - Crear un cliente si no existe siendo la dirección de entrega la que indique un método para agregar una comanda.
  - Parametrizar la frecuencia con la que se envía a cocina los artículos de una comanda. 
  - Parametrizar para habilitar o no la facturación automática luego del envío a cocina. 
  
### Contenido de la documentación 
  + [Arquitectura](#arquitectura)
  + [Versiones soportadas de Tango Restó](#versiones)
  + [Instalación](#instalacion)
    + [Configuración de la terminal](#Configuracion)
    + [Actualización](#actualizaciones)
  + [Métodos](#metodos)
    + [1. AddOrder](#addorder)
    + [2. GetOrders](#GetOrders)
    + [3. GetOrderbyId](#GetOrderbyId)
    + [4. GetOrderbyExternalId](#GetOrderbyExternalId)
    + [5. CancelOrder](#CancelOrder)
    + [6. GetPlatFormList](#GetPlatFormList)
    + [7. GetPaymenetTypes](#GetPaymenetTypes)
    + [8. GetPriceList](#GetPriceList)
    + [9. GetStateOrderList](#GetStateOrderList)
    + [10. GetProductList](#GetProductList)
    + [11. GetProductPriceList](#GetProductPriceList)
    + [12. GetCashRegisterList](#GetCashRegisterList)
    + [13. GetSectionList](#GetSectionList)
    + [14. GetPrintDestination](#GetPrintDestination)
    + [15. SendOrder](#SendOrder)
+ [Código de errores](#errores)
+ [Consideraciones en la vista de los pedidos en Tango Restó versus API método AddOrder ](#Consideraciones)

<br/><br/>

<a name="arquitectura"></a>
## Arquitectura
[<sub>Volver</sub>](#inicio)

![imagenapi](https://github.com/TangoSoftware/RestoAperturaComandasMostradorDelivery/blob/master/00.jpg)

<br/><br/>

<a name="versiones"></a>
### Versiones soportadas de Tango Restô
[<sub>Volver</sub>](#inicio)

En Tango Restó para **Delta 3 o T23**, la versión mínima requerida para habiltar esta funcionalidad es la **23.01.000.2044 o superior**.

En Tango Restó para **Delta 4 o T24**, la versión mínima requerida para habiltar esta funcionalidad es la **24.01.000.4964 o superior**.

En Tango Restó para **Delta 5 o T25**, la versión mínima requerida para habiltar esta funcionalidad es la **25.01.000.2377 o superior**.


<a name="instalacion"></a>
### Instalación
[<sub>Volver</sub>](#inicio)

Para instalar el servicio siga los siguientes pasos:

• Una vez instalada la versión minima requerida para la instalación del servicio, proceda a descargar de la ayuda de API el archivo: **preinstall.resto.api.service.bat** y copiarlo en la ruta de instalación de la aplicación de la API: 
<br/><br/>
**C:\Program Files (x86)\TANGO RESTO\Servidor\Aplicaciones** (versión windows 64bits) o 
<br/><br/>
**C:\Program Files\TANGO RESTO\Servidor\Aplicaciones** (versiòn windows 32 bits) 
 
• Una vez copiado el archivo **preinstall.resto.api.service.bat** en la ruta indicada, deberá ejecutar este archivo como administrador (Click derecho sobre el archivo, ejecutar como administrador)  
 
• Posteriormente el wizard continuará el proceso de instalación.
 
Con estos pasos ya el servicio de API quedará instalado.

**NOTA:** Recuerde actualizar el servicio a la última versión disponible de la API. Para más información por favor dirijase a la sección  [Configuración de la terminal](#Configuracion)

Una vez instalado el servicio **AxApiRestoSvc (Axoft - Servicio de Resto Api)** podrá hacer el llamado a los métodos a través del TokenCS, ejemplo:

```
{
"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS;
Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA"
}
```

Adicional a esto, cada método tiene su propia URL, ejemplo:

```
http://localhost:XXXX/Resto/AddOrder
http://localhost:XXXX/Resto/GetOrders
http://localhost:XXXX/Resto/GetProductList
```
En la URL el parámetro Localhost debe ser reemplazado por el nombre del servidor donde fue instalado el servicio de API Restó, el valor de XXXX será el número del puerto de coexión asignado y, el último parámetro correponde al nombre del método a invocar.

**NOTA:** El valor por defecto del puerto de conexión es 9209. Si desea cambiar este valor, deberá hacerlo en el archivo 'Resto.Api.Service.exe.config' en la sección: 


```
  <appSettings>
    <add key="portNumber" value="9209" />
    <add key="ClientSettingsProvider.ServiceUri" value="" />
```
 
  
    
	 
Para culminar el proceso de instalación se deberá insertar un registro en la tabla TRA_ORIGEN_INFORMACION, este registro es el que identifica a la plataforma de eCommerce con la cual se estaría integrando

Para la tabla TRA_ORIGEN_INFORMACION, el sistema Tango Restó reserva los 10 primeros ID. Por defecto la tabla ya incluye dos registro y en ocasiones se puede encontrar un  tercer registro con valor reservado en el campo ID_TRA_ORIGEN_INFORMACION igual a 3, lo que quiere decir que los siguientes registros a insertar en la tabla deben ser estrictamente mayores a 10 en el valor del campo ID_TRA_ORIGEN_INFORMACION. En el campo DESC_TRA_ORIGEN_INFORMACION tendrá como valor el nombre de la plataforma eCommerce con la que se está integrando.


| **ID_TRA_ORIGEN_INFORMACION** | **DESC_TRA_ORIGEN_INFORMACION** |  
| --- | --- | 
| **1** | Nexo Delivery | 
| **2** | RestÃ´ | 
| **3** | PedidosYa |

<br/><br/>

Ejemplo del Script

INSERT INTO TRA_ORIGEN_INFORMACION (ID_TRA_ORIGEN_INFORMACION, DESC_TRA_ORIGEN_INFORMACION) VALUES ('11', 'Nombre_Plataforma')


<br/><br/>
<a name="Configuracion"></a>
### Configuración de la terminal
[<sub>Volver</sub>](#inicio)
 
Luego de completar el proceso de instalación proceda a configurar la terminal de Restô desde el botón "Otros" que se encuentra en la terminal: Configuración | Terminal, solapa Delivery | Terminal.

 
Desde aquí en la sección “Identificador web” deberá configurar los siguientes parámetros:


• **Notifica nuevo pedido:** Al marcar este parámetro, le está indicando al sistema que la terminal actual va a notificar cuando ingrese un           nuevo pedido a través de un mensaje Pop-up en las vistas activas del sistema.
 
• **Frecuencia:** El valor por defecto será de diez (10) segundos y está relacionado con la frecuencia que el sistema chequeará si existen            nuevos pedidos por notificar en Tango Restó.

• **Pedidos Web a notificar:** Deberá hacer clic en el botón ‘agregar’ para que el sistema le permita seleccionar la(s) plataforma(s) disponible(s) integrada(s) con Tango Restó, registradas en la tabla TRA_ORIGEN_INFORMACION. Una vez seleccionada la plataforma, indique un color para las notificaciones de los nuevos pedidos entrantes en Tango Resto; de igual manera podrá elegir un sonido especifico para cuando el sistema reciba un nuevo pedido.

**NOTA:** Estas notificaciones se configuran por terminal, lo que quiere decir que usted podrá tener terminales en donde puede o no indicarle si desea recibir notificación de la llegada de un nuevo pedido. Es importante mencionar que, al seleccionar un sonido en Restó, el tipo de sonido a reproducir  dependerá según el sonido que tenga configurado en el sistema operativo instalado. Desde el administrador de sonido de Windows podrá modificar el tipo de sonido asociado en Restó  

• **Frecuencia:** El valor por defecto será de diez (10) segundos y está relacionado con la frecuencia que el sistema chequeará si existen nuevos pedidos por notificar en Tango Restó.

• **Pedidos Web a notificar:** Deberá hacer clic en el botón ‘agregar’ para que el sistema le permita seleccionar la(s) terminal(es) donde serán visibles las notificaciones, a continuación indique la(s) plataforma(s) disponible(s) integrada(s) con Tango Restó, registradas en la tabla TRA_ORIGEN_INFORMACION. Una vez seleccionada la plataforma, indique un color para las notificaciones de los nuevos pedidos entrantes en Tango Resto así como; de igual manera podrá elegir un sonido especifico para cuando el sistema reciba un nuevo pedido.

**NOTA:** Siempre que configure las notificaciones de un pedido para las terminales, recuerde guardar los cambios, cerrar las todas las terminales involucradas en la configuración y abrir Restó nuevamente, de esta manera se aplicarán los cambios correspondientes a la configuración de notificaciones.

Para cualquier versión, tenga en cuenta que las comandas pueden ser visibles en el Visor de Mostrador o Delivery según sea el valor del campo Pickup del método AddOrder

Una vez configurada las notificaciones de la(s) plataforma(s), en la subsolapa “visor de pedidos” em la misma solada “Delivery” y en la solapa “Mostradro”, deberá marcar el parámetro “Identificado web” el cual se utiliza para distinguir los pedidos tradicionales de los generados por las plataformas externas.

Por último, en el módulo de mostrador y Delivery se encuentra un nuevo botón en la parte inferior identificado como “Filtro web”, donde podrá marcar las plataforma web de las cuales desea visualizar los pedidos correspondientes en los visores delivery y mostrador.
  
 

<br/><br/>
<a name="actualizaciones"></a>
### Actualización
[<sub>Volver</sub>](#inicio)

La última versión del hotfix para **Delta 3 o T23** es : ** 23_01_000_4677** con **Versión del instalador**: 23.1.0.34 (INSTALLERRESTOAPISERVICE.EXE) 

La última versión del hotfix para **Delta 4 o T24** es : ** 24_01_000_4837** con **Versión del instalador**: 24.1.0.34 (INSTALLERRESTOAPISERVICE.EXE) 

La última versión del hotfix para **Delta 5 o T25** es : ** 25_01_000_2377** con **Versión del instalador**: 25.1.0.14 (INSTALLERRESTOAPISERVICE.EXE) 

Para aplicar esta actualización se deberán seguir los siguientes pasos:

• Descargar del sitio web https://nexo.axoft.com/ el Hotfix e instalarlo en el servidor   
 
• Descargar de la ayuda de API el archivo: **preinstall.resto.api.service.bat** y copiarlo en la ruta de instalación de la aplicación de la API: 
<br/><br/>
**C:\Program Files (x86)\TANGO RESTO\Servidor\Aplicaciones** (versión windows 64bits) o 
<br/><br/>
**C:\Program Files\TANGO RESTO\Servidor\Aplicaciones** (versiòn windows 32 bits) 
 
• Una vez copiado el archivo **preinstall.resto.api.service.bat** en la ruta indicada, deberá ejecutar este archivo como administrador (Click derecho sobre el archivo, ejecutar como administrador)  
 
• Posteriormente el wizard de instalación le preguntará si desea sustituir los archivos, deberá seleccionar la opción Si a todo (Yes all) 
 
Con estos pasos ya el servicio de API quedará actualizado a la versión que contiene el Hoftix instalado. 
 
**NOTA:** La descarga del archivo **preinstall.resto.api.service.bat** de este portal puede hacerlo una sola vez sin embargo, siempre que instale un Hotfix y éste impacte directamente en ajustes y mejoras de la API, usted deberá ejecutar como administrador el archivo **preinstall.resto.api.service.bat** en la ruta que corresponda en la instalación de la API.
 

<br/><br/>

<a name="metodos"></a>
## Métodos
[<sub>Volver</sub>](#inicio)

<a name="addorder"></a>
### 1. AddOrder (POST)
[<sub>Volver</sub>](#inicio)

  Este método permite registrar una nueva orden de pedido en la base de datos del sistema Tango Restó

####   Request
     - TokenCS
     - CashCode
     - Object Order
     
 ####   Formato del JSON
     
```
{
"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS;
Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA",
	"cashCode" : "1",
	"order" : {
		"ExternalId" : 3001,
		"platformId" : "1",
		"RegisteredDate" : "06/08/2020",
		"DeliveryDate" : "06/08/2020",
		"PickUp" : false,
		"PickupDate" : "06/08/2020",
                "PickupTime": "16:24",
		"DelayTime": 15,
		"Notes" : "Nota para la comanda",
		"PriceListCode" : 1,
		
		"Customer" : {
				"name" : "Jorge Chaar",
				"email" : "jorgea@axoft.com"
		},
		
		"Address" : {
			 "Description" : "Yerbal",
			 "Phone" : "1569812178",
			 "Notes": "",
			 "ZipCode": "1504",
			 "City": "Caballito",
			 "Street": "Yerbal",
			 "Number": "773",
			 "Area" : "",
			 "Corner": "Rojas",
			 "Complement": "",
			 "Department": "6 E"
		},
		
		"Details" : [
			{
				"Code": "001",
				"Quantity": 2,
				"UnitPrice": 200.0,
				"Notes" : "sin sal"
			},
			{
				"Code": "002",
				"Quantity": 1,
				"UnitPrice": 200.0,
				"Notes" : ""
			},
			
			{
				"Code": "913",
				"Quantity": 1,
				"UnitPrice": 1200.0,
				"Notes" : "",
				"OptionGroups": [
					{
						"IntegrationCode": "521",
						"Quantity": 12,
						"Amount": 100
					}
				]
			}
		],
		
		"Discount" : {
			"Type" : "I",
			"Amount" : 10
		},
		
		"Surcharge" : {
			"Type" : "P",
			"Amount": 5
		},
		
				"Payments" : [
			{
				"Code" : 1,
				"PaymentAmount" : 900,
				"Online" : true
			}
		]
	}
}

``` 
 ####   Curl
     
```
curl --location 'http://NOMBRE_SERVIDOR_LOCAL:9209/Resto/AddOrder' \
--header 'Content-Type: application/json' \
--data-raw '
{
"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS; Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA",
	"cashCode" : "1",
	"order" : {
	"ExternalId" : 954,
		"platformId" : "4",
		"RegisteredDate" : "09/09/2025",
		"DeliveryDate" : "09/09/2025",
		"PickUp" : false,
		"PickupDate" : "09/09/2025",
        "DelayTime" : 0,
		"Notes" : "Nota para la comanda",
		"DeliveryTimeID" : 0,
		"MotivoRechazoID" : 0,
		"PriceListCode" : 1,
		
		"Customer" : {
				"name" : "Jorge Chaar",
				"email" : "jorgea@axoft.com"
		},
		
		"Address" : {
			 "Description" : "Yerbal",
			 "Phone" : "1569812178",
			 "Notes": "",
			 "ZipCode": "1504",
			 "City": "Caballito",
			 "Street": "Yerbal",
			 "Number": "773",
			 "Area" : "",
			 "Corner": "Rojas",
			 "Complement": "",
			 "Department": "6 E"
		},
		
		"Details" : [
			{
				"Code": "001",
				"Quantity": 2,
				"UnitPrice": 200.0,
				"Notes" : "sin sal"
			},
			{
				"Code": "002",
				"Quantity": 1,
				"UnitPrice": 200.0,
				"Notes" : ""
			},
			
			{
				"Code": "913",
				"Quantity": 1,
				"UnitPrice": 1200.0,
				"Notes" : "",
				"OptionGroups": [
					{
						"IntegrationCode": "521",
						"Name": null,
						"Options": null,
						"Quantity": 12,
						"Amount": 100,
						"QDOrderDetailID": 0,
						"ModifiesPrice": false,
						"QDOrdersDetails": null,
						"QDOrdersDetails" : {
							"Quantity" : 1
						}
					}
				]
			}
		],
		
		"Discount" : {
			"Type" : "I",
			"Amount" : 10
		},
		
		"Surcharge" : {
			"Type" : "P",
			"Amount": 5
		}
	}
}'

``` 

####  Datos del JSON

**Información CashCode**

| **Campo** | **Requerido** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** | 
| --- | --- | --- | --- |--- |
| **CashCode** | Si | Código del puesto de caja asigando a la comanda | Integer(8) | 1 |

<br/><br/>

**Información Order**

Estos datos son obligatorios para dar de alta a una orden
| **Campo** | **Requerido** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** | 
| --- | --- | --- | --- |--- |
| **ExternalId** | Si | Número de la orden externa | Integer(8) | 3000 |
| **platformId** | Si| Número de la plataforma externa | D_ID(4) | 3 |
| **RegisteredDate** | Si | Fecha de registro de la orden | Date | DD/MM/AAAA |
| **DeliveryDate** | Si | Fecha estimada de entrega de la comanda | Date | DD/MM/AAAA |
| **PickUp** | Si | La comanda será vista desde delivery o mostrador | Varchar(10) | True = Mostrador o False = Delivery |
| **PickupDate** | Si | Fecha registro de entrega de la comanda | Date | DD/MM/AAAA |
| **PickupTime** | No | Hora registro de entrega de la comanda | String | HH:MM |
| **DelayTime** | No | Minutos de demora en la  entrega de la comanda | Integer | 0 |
|  **Notes** | No | Nota para la comanda | Varchar(-1) | Colocar servilletas extras |
|  **PriceListCode** | Si | Número de la lista de precio asicada a la comanda | ENTERO_TG | 1 |

<br/><br/>

**Información Customer**

| **Campo** | **Requerido** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** | 
| --- | --- | --- | --- |--- |
|  **Name** | Si | Nombre y apellido del cliente | Varchar(500 | Juan Martinez |
|  **Email** | Si | Correo electrónico del cliente | Varchar(500 | juanmartinez@ejemplo.com |

<br/><br/>

**Información Address**

| **Campo** | **Requerido** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** | 
| --- | --- | --- | --- |--- |
|  **Description** | No | Descripción de la dirección del cliente | Varchar(500 | Dirección Principal |
|  **Phone** | No | Número telefónico del cliente | Varchar(200 | 54113426578 |
|  **Notes** | No | Nota para la dirección del cliente | Varchar(-1) | Puerta de madera |
|  **ZipCode** | No | Código postal de la dirección del cliente | Varchar(40) | 1019 |
|  **City** | No | Ciudad | Varchar(500) | Capital Federal |
|  **Street** | Si | Nombre de la calle de la dirección del cliente| Varchar(500) | Esmeralda |
|  **Number** | Si | Número o altura de la calle de la dirección del cliente | Varchar(40) | 1120 |
|  **Area** | No | localidad de la dirección del cliente | Varchar(500) | Retiro |
|  **Corner** | No | Esquina referencial a la calle de la dirección del cliente | Varchar(500) | Corriente |
|  **Complement** | No | Identificación del número del Piso de la dirección del cliente | Varchar(500) | PB |
|  **Department** | No | Identificación del departamento de la dirección del cliente | Varchar(500) | 5A |

<br/><br/>

**Información Details**

| **Campo** | **Requerido** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** | 
| --- | --- | --- | --- |--- |
|  **Code** | Si | Codigo del artículo  | Varchar(15) | AC001 |
|  **Quantity** | Si | Cantidad del artículo | DECIMAL_TG | 2.0 |
|  **UnitPrice** | Si | Precio unitario del artículo  | DECIMAL_TG | 200.0 |
|  **Notes** | No | Nota para el artículo | Varchar(-1) | Sin sal |

<br/><br/>

**Información OptionGroups**

Estos datos solo serán necesarios si se trata de un artículo del tipo promoción
| **Campo** | **Requerido** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** | 
| --- | --- | --- | --- |--- |
|  **IntegrationCode** | Si | Código del artículo que forma parte de una promoción en el detalle de la comanda | Varchar(15) | GAS009 |
|  **Quantity** | Si | Cantidad del artículo que forma parte del artículo promoción | DECIMAL_TG | 1.0 |
|  **Amount** | Si | Precio unitario del artículo que fomra parte de la promoción  | DECIMAL_TG | 20.0 |

<br/><br/>

**Información Discount**

Estos datos serán necesarios si la orden tiene algun tipo de descuento
| **Campo** | **Requerido** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** | 
| --- | --- | --- | --- |--- |
|  **Type** | Si | Indica si el valor del descuento a aplicar será en porcentaje o en importe  | Varchar(1) | I = Importe o P = Porcentaje |
|  **Amount** | Si | Valor a aplocar del descuento  | DECIMAL_TG | 20 |

<br/><br/>

**Información Surcharge**

Estos datos serán necesarios si la orden tiene algún tipo de recargo
| **Campo** | **Requerido** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** | 
| --- | --- | --- | --- |--- |
|  **Type** | Si | Indica si el valor del recargo a aplicar será en porcentaje o en importe  | Varchar(1) | I = Importe o P = Porcentaje |
|  **Amount** | Si | Valor a aplocar del recargo  | DECIMAL_TG | 20 |


<br/><br/>


**Información Payments**

Estos datos serán necesario si la orden tiene algún tipo de medio de pago registrado
| **Campo** | **Requerido** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** | 
| --- | --- | --- | --- |--- |
|  **Code** | Si | Representa el código de la cuenta de caja  | Varchar(15) | 1 |
|  **PaymentAmount** | Si | Representa el monto abonado con la cuenta de caja  | DECIMAL_TG | 20 |
| **Online** | Si | Permite visualiar en la comanda la cuenta de caja que ya tiene asociada al momento de abonar la comanda | Varchar(10) | True  |
<br/><br/>

<a name="GetOrders"></a>
### 2. GetOrders (GET)
[<sub>Volver</sub>](#inicio)

  Devuelve las comandas del módulo delivery y/o mostrador registradas en Tango Restó durante las últimas   24 horas; las comandas pudieron ser generadas desde el sistema Tango Restó o desde una aplicación  externa.
  
####   Request
     - TokenCS
    
     
 ####   Formato del JSON

```
{
"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS;
Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA"
}
```
 ####   Curl
     
```

curl --location --request GET 'http://NOMBRE_SERVIDOR_LOCAL:9209/Resto/GetOrders' \
--header 'Content-Type: application/json' \
--data '{"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS; Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA"
}'

``` 

<a name="GetOrderbyId"></a>
### 3. GetOrderbyId (GET)
[<sub>Volver</sub>](#inicio)

   Devuelve una comanda específica a través del Id de la comanda registrada en Tango Restó.   
  
####   Request
     - TokenCS
     - Id 
    
     
 ####   Formato del JSON


```
{
"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS;
Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA",
Id : 508
}
```

 ####   Curl
     
```
curl --location --request GET 'http://NOMBRE_SERVIDOR_LOCAL:9209/Resto/GetOrderById' \
--header 'Content-Type: application/json' \
--data '{
	"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS;Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA",
	"id" : Número de la orden de la comanda registrada en Tango Restó
}'

```

**Información GetOrderById**

| **Campo** | **Requerido** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** | 
| --- | --- | --- | --- |--- |
| **Id** | Si | Número de la orden de la comanda registrada en Tango Restó | Integer(8) | 3000 |

<br/><br/>

<a name="GetOrderbyExternalId"></a>
### 4. GetOrderbyExternalId (GET)
[<sub>Volver</sub>](#inicio)

   Devuelve una comanda especifica pasando como parámetros el ID de la comanda que viene de la aplicación externa y, el ID de la plataforma de origen
  
####   Request
     - TokenCS
     - ExternalId 
     - PlatformId
    
     
 ####   Formato del JSON

```
{
"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS;
Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA",
"ExternalId" : "508",
"PlatformId" : "5"
}
```

 ####   Curl
     
```
curl --location --request GET 'http://NOMBRE_SERVIDOR_LOCAL:9209/Resto/GetOrderByExternalId/' \
--header 'Content-Type: application/json' \
--data '{
	"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS;Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA",
	"ExternalId" : "Número de la comanda generada desde la plataforma externa",
	"platformId" : "Número de la plataforma externa"
}'

``` 

**Información GetOrderByExternalId**

| **Campo** | **Requerido** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** | 
| --- | --- | --- | --- |--- |
| **ExternalId** | Si | Número de la comanda generada desde la plataforma externa | Integer(8) | 3000 |
| **PlatformId** | Si| Número de la plataforma externa | D_ID(4) | 4 |

<br/><br/>

<a name="CancelOrder"></a>
### 5. CancelOrder (POST)
[<sub>Volver</sub>](#inicio)

   Este método permite anular una comanda, para ello es necesario enviar como parámetros el Id de la comanda de Tango Restó
  
####   Request
     - TokenCS
     - Id 
     
    
     
 ####   Formato del JSON

```
{
"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS;
Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA",
Id : 508
}
```

 ####   Curl
     
```
curl --location 'http://NOMBRE_SERVIDOR_LOCAL:9209/Resto/CancelOrder ' \
--header 'Content-Type: application/json' \
--data '{
	"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS;Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA",
	"id" : Número de la comanda en Tango Restó
}'

```

**Información CancelOrder**

| **Campo** | **Requerido** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** | 
| --- | --- | --- | --- |--- |
| **Id** | Si | Número de la comanda en Tango Restó | Integer(8) | 3000 |

<br/><br/>

<a name="GetPlatFormList"></a>
### 6. GetPlatFormList (GET)
[<sub>Volver</sub>](#inicio)

   Este método devuelve todas las plataformas externas disponibles qpara las integraciones. 
  
####   Request
     - TokenCS
     
      
     
 ####   Formato del JSON

```
{
"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS;
Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA"
}
```

 ####   Curl
     
```
curl --location --request GET 'http://NOMBRE_SERVIDOR_LOCAL:9209/Resto/GetPlatformList' \
--header 'Content-Type: application/json' \
--data '{
		"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS;Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA"
}'

``` 

**Información Response JSON GetPlatFormList**

| **Campo** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** | 
| --- | --- | --- |--- |
| **Id** |  Número de la plataforma externa | Integer(8) | 4 |
| **Description** |  Nombre de la plataforma o aplicaciñon externa | Varchar(40) | Uber |

<br/><br/>

<a name="GetPaymenetTypes"></a>
### 7. GetPaymenetTypes (GET)
[<sub>Volver</sub>](#inicio)

   Este método devuelve todas los medios de pago o cuentas de caja disponibles. 
  
####   Request
     - TokenCS
     
        
     
 ####   Formato del JSON

```
{
"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS;
Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA"
}
```

 ####   Curl
     
```
curl --location --request GET 'http://NOMBRE_SERVIDOR_LOCAL:9209/Resto/GetPaymentTypes' \
--header 'Content-Type: application/json' \
--data '{
	"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS;Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA"
}'

```

**Información Response JSON GetPaymenetTypes**

| **Campo** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** | 
| --- | --- | --- |--- |
| **Code** | Código de la cuenta de caja| Integer(8) | 4 |
| **Description** |  Descripción de la cuenta de caja | Varchar(40) | Uber |

<br/><br/>

<a name="GetPriceList"></a>
### 8. GetPriceList (GET)
[<sub>Volver</sub>](#inicio)

   Este método devuelve todas las listas de precio disponibles. 
  
####   Request
     - TokenCS
     
         
     
 ####   Formato del JSON

```
{
"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS;
Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA"
}
```

 ####   Curl
     
```
curl --location --request GET 'http://NOMBRE_SERVIDOR_LOCAL:9209/Resto/GetPriceList' \
--header 'Content-Type: application/json' \
--data '{
	"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS;Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA"
}'

```

**Información Response JSON GetPriceList**

| **Campo** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** | 
| --- | --- | --- |--- |
| **Code** | Número de la lista de precio | Integer(8) | 4 |
| **Description** |  Descripción de la lista de precio | Varchar(40) | Uber |

<br/><br/>

<a name="GetProductList"></a>
### 9. GetProductList (GET)
[<sub>Volver</sub>](#inicio)

   Este método devuelve  los artículos disponibles en Tango Restó cuyo perfil sea
 
      - Venta
      - Compra / Venta
      
  
####   Request
     - TokenCS
     
             
 ####   Formato del JSON

```
{
"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS;
Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA"
}
```

 ####   Curl
     
```
curl --location --request GET 'http://NOMBRE_SERVIDOR_LOCAL:9209/Resto/GetProductList' \
--header 'Content-Type: application/json' \
--data '{
	"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS;Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA"
}'

```

**Información Response JSON GetProductList**

| **Campo** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** | 
| --- | --- | --- |--- |
| **Code** | Código del artículo | Varchar(-1) | AC092 |
| **Description** |  Descripción del artículo | Varchar(30) | AGUA MINERAL |
| **Type** |  Indica su el artículo es simple, receta o promoción | Varchar(1) | A = Simple, M = Receta, P = Promoción |
| **Profile** |  Indica su el artículo es de venta o compra / venta | Varchar(1) | A = Compra / Venta, V = Venta |
| **GroupType** |  Si el artículo es del tipo P (promoción) este campo podrá indicar si la promoción es fija o variable | Varchar(1) | F = Fija, V = Variable |

<br/><br/>

**Información OptionGroups**

Estos datos solo serán visualizados si se trata de un artículo del tipo promoción
| **Campo** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** |
| --- | --- | --- |--- |
|  **IntegrationCode** | Código del artículo que forma parte de una promoción | Varchar(15) | GAS009 |
|  **Quantity** | Cantidad del artículo que forma parte del artículo promoción | DECIMAL_TG | 1.0 |

<br/><br/>


<a name="GetStateOrderList"></a>
### 10. GetStateOrderList (GET)
[<sub>Volver</sub>](#inicio)

   Este método devuelve los diferentes estados que puede tener una comanda
  
####   Request
     - TokenCS
      
     
 ####   Formato del JSON

```
{
"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS;
Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA"
}
```

 ####   Curl
     
```
curl --location --request GET 'http://NOMBRE_SERVIDOR_LOCAL:9209/Resto/GetStateOrderList' \
--header 'Content-Type: application/json' \
--data '{
	"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS;Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA"
}'

```

**Información Response JSON GetStateOrderList**

| **Campo** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** | 
| --- | --- | --- |--- |
| **State** | Estado de la comanda | Varchar(1) | A |
| **Description** |  Descripción es el estado de la comanda | Varchar(40) | Abierta |

<br/><br/>

<a name="GetProductPriceList"></a>
### 11. GetProductPriceList (GET)
[<sub>Volver</sub>](#inicio)

   Este método permite ver si un artículo esta relacionado con una o mas listas de precio
  
####   Request
     - TokenCS
      
     
 ####   Formato del JSON

```
{
"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS;
Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA"
}
```

 ####   Curl
     
```
curl --location --request GET 'http://NOMBRE_SERVIDOR_LOCAL:9209/Resto/GetProductPriceList' \
--header 'Content-Type: application/json' \
--data '{
	"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS;Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA"
}'

``` 

**Información Response JSON GetProductPriceList**

| **Campo** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** | 
| --- | --- | --- |--- |
| **Price** | Es el precio del artículo | DECIMAL_TG | 200.0 |
| **ProductCode** | Código del artículo | Varchar(-1) | AC098 |
| **PriceListCode** | Número de la lista de precio | Integer(8) | 1 |

<br/><br/>

<a name="GetCashRegisterList"></a>
### 12. GetCashRegisterList (GET)
[<sub>Volver</sub>](#inicio)

   Este método devuelve todos los puestos de cajas disponibles en Tango Restó
  
####   Request
     - TokenCS
      
     
 ####   Formato del JSON

```
{
"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS;
Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA"
}
```

 ####   Curl
     
```
curl --location --request GET 'http://NOMBRE_SERVIDOR_LOCAL:9209/Resto/GetCashRegisterList' \
--header 'Content-Type: application/json' \
--data '{
	"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS;Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA"
}'

``` 
**Información Response JSON GetCashRegisterList**

| **Campo** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** | 
| --- | --- | --- |--- |
| **Code** | Es el código del puesto de caja  | ENTERO_TG | 1 |
| **Description** | Descripción del puesto de caja | Varchar(30) | Caja Central |

<br/><br/>

<a name="GetSectionList"></a>
### 13. GetSectionList (GET)
[<sub>Volver</sub>](#inicio)

   Este método devuelve todos los rubros disponibles en Tango Restó
  
####   Request
     - TokenCS
      
     
 ####   Formato del JSON

```
{
"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS;
Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA"
}
```

 ####   Curl
     
```
curl --location --request GET 'http://NOMBRE_SERVIDOR_LOCAL:9209/Resto/GetSectionList' \
--header 'Content-Type: application/json' \
--data '{
	"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS;Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA"
}'

```

**Información Response JSON GetSectionList**

| **Campo** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** | 
| --- | --- | --- |--- |
| **Code** | Es el código del rubro  | ENTERO_TG | 1 |
| **Description** | Descripción del rubro | Varchar(30) | Bebidas |

<br/><br/>

<a name="GetPrintDestination"></a>
### 14. GetPrintDestination (GET)
[<sub>Volver</sub>](#inicio)
      
   Este método devuelve todos los destinos de impresión disponibles en Tango Restó
    
####   Request
     - TokenCS
      
     
 ####   Formato del JSON

```
{
"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS;
Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA"
}
```

**Información Response JSON GetPrintDestination**

| **Campo** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** | 
| --- | --- | --- |--- |
| **PrinterCode** | Es el código del destino de impresión  | Varchar(3) | 011 |
| **PrinterName** | Nombre del destino de impresión | Varchar(30) | Cocina |

<br/><br/>

<a name="SendOrder"></a>
### 15. SendOrder (POST) 
[<sub>Volver</sub>](#inicio)

  Este método permite enviar a cocina de manera automática cada artículo de una comanda. Además, permite la facturación automática según parametrización. 

 
####   Request
     - TokenCS
     - Id 
     - DestinoCocina
     - DestinoComp
     - habilitaFacturaAuto 
     
    

 ####   Formato del JSON


```
Ejemplo 1
{ 
"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS; 
Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA", 
Id_comanda : 508,
DestinoCocina: "\\TANGO\\COCINA",
DestinoComp: "TALONARIO",
habilitaFacturaAuto": 1
}

Ejemplo 2
{ 
"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS; 
Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA", 
Id_comanda : 508,
habilitaFacturaAuto : 0 
}
```

 ####   Curl
     
```
curl --location 'http://NOMBRE_SERVIDOR_LOCAL:9209/Resto/SendOrder' \
--header 'Content-Type: application/json' \
--data '{
 "TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS;Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA",
	"ID_COMANDA":"Nro de comanda",
    "habilitaFacturaAuto": 0
}'

``` 

**Información SendOrder**

| **Campo** | **Requerido** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** | 
| --- | --- | --- | --- |--- |
| **Id_Comanda** | Si | Nro de comanda | Integer(8) | 3000 |
| **"DestinoCocina"** | No | Nombre de la impresora o recurso compartido en Windows por donde saldrá impresa la comanda completa cuya orden tiene origen desde la API | Varchar(200) | \\TANGO\\COCINA |
| **DestinoComp** | No | Nombre  de la impresora o recurso compartido en Windows por donde saldrá impreso el comprobante de venta cuya orden tiene origen desde la API | Varchar(200) | CAJA |
| **habilitaFacturaAuto** | Si | Habilita facturación automática | Bit | 1 |


**Response 200 SendOrder**

```
{ 
"order" : null, 
"Success": true, 
"Error":  null 
} 
```

**Consideraciones**

Para poder utilizar dicho método, es necesario realizar la parametrización en la configuración de la terminal de Restó, en la solapa “Procesos automáticos”. Se deberá indicar la frecuencia con la que se desea que se ejecute el proceso automático y los minutos máximos respecto a la fecha acordada para el pedido que se considerarán para enviar a cocina. Además, en caso de no hacer uso del TAG “DelayTime” en el JSON del método AddOrder, debe existir al menos un tiempo promedio estimado de entrega en los parámetros generales de al menos un minuto.

En EndPoint no impacta en el funcionamiento de impresión de comandas que hace hoy en día el sistema Restó, se considera como un adicional en el proceso, por lo cual no interfiere en ningún momento en la parametrización que se haga de manera general o particular en la impresión de comandas, es decir, este proceso continuará su camino habitual. 

Es un requisito que Restó tenga parametrizado al menos una forma de impresión de comanda para el sector de Delivery  desde los parámetros generales si desea que desde la API sea impreso el envío a cocina.

Los comprobantes de ventas solo serán emitidos por la impresora cuando el valor le sea pasado en el EndPoint de la API  y, además cuando el valor del habilitaFacturaAuto le sea pasado como valor '1'.

Recuerde que los nombres o recursos compartidos deben estar correctamente configurados y definidos. En el caso de recursos compartidos, asegúrese de que el usuario de Windows cuente con los permisos adecuados para acceder a dichos recursos. Esto garantizará que el proceso de impresión de comandas y comprobantes de ventas se realice de manera exitosa a través de la API.


<br/><br/>

<a name="errores"></a>

## Código de errores
[<sub>Volver</sub>](#inicio)


| **Entidad** | **Código** | **Mensaje** |
| --- | --- | --- |
| **TokenCS** | E0001 | No es posible conectarse  Por favor verifique los datos del TokenCS |
| **Identificador** | E0101 | El Id no existe |
| **Identificador** | E0102 | El Id es un campo obligatorio |
| **Identificador** | E0103 | El ExternalId no existe |
| **Identificador** | E0104 | El ExternalId es un campo obligatorio |
| **Identificador** | E0105 | El PlatformId no existe |
| **Identificador** | E0106 | El PlatformId es un campo obligatorio |
| **Identificador** | E0136 | El ExternalId ya existe para la plataforma ‘PlatformId’ |
| **Caja** | E0107 | El CashCode es un campo obligatorio |
| **Caja** | E0108 | El CashCode no existe |
| **Fecha** | E0109 | El RegisteredDate es un campo obligatorio |
| **Fecha** | E0110 | El RegisteredDate no puede ser mayor a la fecha actual del sistema |
| **Fecha** | E0111 | El DeliveryDate no puede ser menor al campo RegisteredDate |
| **Fecha** | E0112 | El DeliveryDate es un campo obligatorio |
| **Entrega** | E0113 | El PickUp es un campo obligatorio |
| **Entrega** | E0114 | El valor del campo PickUp no es válido |
| **Fecha** | E0115 | El campo PickupDate  es un campo obligatorio |
| **Fecha** | E0116 | El campo PickupDate  no puede ser menor al valor del campo RegisteredDate |
| **Lista de precio** | E0117 | El valor de PriceListCode es un campo obligatorio |
| **Lista de precio** | E0118 | El valor de PriceListCode no existe |
| **Cliente** | E0120 | El nombre del cliente es un dato obligatorio |
| **Cliente** | E0121 | El EMail del cliente es un dato obligatorio |
| **Artículo** | E0122 | El valor del campo Code es un dato obligatorio |
| **Artículo** | E0123 | El valor del campo Code no existe |
| **Artículo** | E0124 | El valor del campo Quantity debe ser mayor a cero |
| **Agrupador de artículo** | E0125 | El valor del campo IntegrationCode es un campo obligatorio |
| **Agrupador de artículo** | E0126 | El valor del campo IntegrationCode no existe |
| **Agrupador de artículo** | E0127 | El valor del campo Amount es un campo obligatorio |
| **Descuento** | E0128 | El valor del campo Type no es correcto |
| **Descuento** | E0129 | El valor del campo Amount es un campo obligatorio |
| **Recargo** | E0130 | El valor del campo Amount es un campo obligatorio |
| **Recargo** | E0131 | El valor del campo Type no es correcto |
| **Medio de pago** | E0132 | El valor del campo code del array payments no existe |
| **Medio de pago** | E0133 | El valor del campo code del array payments es obligatorio |
| **Medio de pago** | E0134 | El valor del campo PaymentAmount debe ser mayor a cero |
| **Medio de pago** | E0135 | El valor del campo Online debe ser true |
| **General** | E0136 | No existe un turno abierto para el valor CashCode |
| **General** | E9999 | Error no esperado |

<br/><br/>

<a name="Consideraciones"></a>
### Consideraciones en la vista de los pedidos en Tango Restó versus API método AddOrder
[<sub>Volver</sub>](#inicio)

1.- Los códigos de los artículos que se envían en el **Request** deben existir en la base de datos. En caso de no existir el artículo, dentro de la orden ingresada desde la API se visualizará el artículo con descripción **“Producto Fuera de menú”**. Sin embargo, si en la sección del artículo 
 
    { 
        "Code": "", 
        "Name": "", 
        "Quantity": , 
        "UnitPrice": , 
        "Total": , 
        "Notes": "", 
        "OptionGroups": [] 
      }, 
       

si el objeto **Name** señala un valor, cuando el código del artículo no existe en la base de datos, y el sistema muestra en la comanda “Producto Fuera de menú”,  el valor del objeto Name será visible como una nota debajo para el del artículo **“Producto Fuera de menú”**.

2.- El método **GetProductList** devuelve como Response información del artículo en cuestión, de las cuales se debe tomar en consideración entre otras las siguientes. Profile  y Type

   **Profile**: Indica el perfil del artículo: venta (V), compra (C) y compra/venta (A) 
   **Type**: Indica el tipo del artículo:  simple (A), promo (P), receta (M)

3.- Al enviar el **Details** de la orden en el **Request** del método **Addorder**, se debe mantener el mismo criterio que se utiliza en la implementación del sistema Tango Restó en cuanto al alta de artículos para obtener el comportamiento esperado durante la cargar de una comanda directamente desde el módulo Delivery o mostrador.  Este comportamiento y visibilidad de los artículos en la comanda depende del Type y el Pofile de los artículos.

Para que un artículo sea visible correctamente en una comanda, deberá cumplir las siguientes condiciones:

• El **Profile** debe ser diferente a compras (C) 
 
• Si el **Type** es simple (A) el mismo no podrá contener **OptionGroup**
 
• Los artículos cuyo **Type** sea igual a promo (P), solo podrán tener como **OptionGroup** aquellos artículos cuyo **Type** sea del tipo simple (A). Restó mantendrá el
comportamiento del artículo promo según esté definido en el campo "GroupType", pudiendo tener dos valores: fija (F) o variable (V)
 

4.- Para visualizar las comandas que son ingresadas a través de la API, es importante activar el **filtro “WEB”** en el panel principal de visor de pedidos en mostrador o delivery, 

