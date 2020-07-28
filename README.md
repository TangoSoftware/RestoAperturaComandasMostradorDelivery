<a name="inicio"></a>
# Resto Apertura Comandas (Mostrador y Delivery)

La API permite registrar en la base de datos de Tango Restó, las comandas o pedidos generados por aplicaciones externas. Esta información es recibida como parámetros de entrada y la comanda será visualiza en el módulo de Delivery o Mostrador según sea el caso.

Desde Restô se podrá:
  - Identificar el origen de la comanda. 
  - Cancelar una comanda.
  - Crear un cliente si no existe siendo la dirección de entrega la que indique un método para agregar una comanda.
  
### Contenido de la documentación 
  + [Versiones soportadas de Tango Restó](#versiones)
  + [Instalación](#instalacion)
  + [Arquitectura](#arquitectura)
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
+ [Código de errores](#errores)

<a name="versiones"></a>
### Versiones soportadas de Tango Restô
[<sub>Volver</sub>](#inicio)

La versión mínima requerida de Tango Restô para habiltar esta funcionalidad es la **19.01.000.2576 o superior**.


<a name="instalacion"></a>
### Instalación
[<sub>Volver</sub>](#inicio)

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

Para culminar el proceso de instalación se deberá insertar un registro en la tabla TRA_ORIGEN_INFORMACION, este registro es el que identifica a la plataforma de eCommerce con la cual se estaría integrando

Por defecto la tabla TRA_ORIGEN_INFORMACION ya incluye dos registro y tiene un tercer registro con valor reservado en el campo ID_TRA_ORIGEN_INFORMACION, con valor 3, lo que quiere decir que los siguientes registros a insertar en la tabla deben ser estrictamente mayores a 3 en el valor del campo ID_TRA_ORIGEN_INFORMACION. En el campo DESC_TRA_ORIGEN_INFORMACION tendrá como valor el nombre de la plataforma eCommerce con la que se está integrando.


| **ID_TRA_ORIGEN_INFORMACION** | **DESC_TRA_ORIGEN_INFORMACION** |  
| --- | --- | 
| **1** | Nexo Delivery | 
| **2** | RestÃ´ | 
| **3** | PedidosYa |

<br/><br/>

Ejemplo des Script

INSERT INTO TRA_ORIGEN_INFORMACION (ID_TRA_ORIGEN_INFORMACION, DESC_TRA_ORIGEN_INFORMACION) VALUES ('4', 'Nombre_Plataforma')

<br/><br/>

<a name="arquitectura"></a>
## Arquitectura
[<sub>Volver</sub>](#inicio)

![imagenapi](https://github.com/TangoSoftware/RestoAperturaComandasMostradorDelivery/blob/master/00.jpg)

<a name="metodos"></a>
## Métodos
[<sub>Volver</sub>](#inicio)

<a name="addorder"></a>
### 1. AddOrder (POS)
[<sub>Volver</sub>](#inicio)

  Este método permite registrar una nueva orden de pedido en la base de datos del sistema Tango Restó

####   Request
     - TokenCS
     - CashCode
     - Object Order
     
 ####   Formato del JSON
     
```
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
		"Notes" : "Nota para la comanda",
		"PriceListCode" : 1,
		
		"Customer" : {
				"name" : "Jorge Chaar",
				"email" : "jorgea@axoft.com"
		},
		
		"Address" : {
			 "Description" : "Yerbal",
			 "Phome" : "1569812178",
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
| **RegisteredDate** | Si | Fecha de registro de la orden | Date | mm/dd/aaaa |
| **DeliveryDate** | Si | Fecha estimada de entrega de la comanda | Date | mm/dd/aaaa |
| **PickUp** | Si | La comanda será vista desde delivery o mostrador | Varchar(10) | True = Delivery o False = Mostrador |
| **PickupDate** | Si | Fecha registro de entrega de la comanda | Date | mm/dd/aaaa |
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
|  **Phome** | No | Número telefónico del cliente | Varchar(200 | 54113426578 |
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
|  **Quantity** | Si | Cantidad del artículo | Integer(4) | 2 |
|  **UnitPrice** | Si | Precio unitario del artículo  | DECIMAL_TG | 200.0 |
|  **Notes** | No | Nota para el artículo | Varchar(-1) | Sin sal |

<br/><br/>

**Información OptionGroups**

Estos datos solo serán necesarios si se trata de un artículo del tipo promoción
| **Campo** | **Requerido** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** | 
| --- | --- | --- | --- |--- |
|  **IntegrationCode** | Si | Código del artículo que forma parte de una promoción en el detalle de la comanda | Varchar(15) | GAS009 |
|  **Quantity** | Si | Cantidad del artículo que forma parte del artículo promoción | Integer(4) | 1 |
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
     - Id 
     - PlatformId
    
     
 ####   Formato del JSON

```
{
"TokenCS": "Data Source=NOMBRE_SERVIDOR_TANGO;Initial Catalog=NOMBRE_BASE_DE_DATOS;
Integrated Security=False;User ID=NOMBRE_USUARIO;Password=CONTRASEÑA",
Id : 508, "PlatformId" : 5
}
```

**Información GetOrderByExternalId**

| **Campo** | **Requerido** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** | 
| --- | --- | --- | --- |--- |
| **Id** | Si | Número de la comanda generada desde la plataforma externa | Integer(8) | 3000 |
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

**Información Response JSON GetProductList**

| **Campo** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** | 
| --- | --- | --- |--- |
| **Code** | Código del artículo | Varchar(-1) | AC092 |
| **Description** |  Descripción del artículo | Varchar(30) | AGUA MINERAL |
| **Type** |  Indica su el artículo es simple, receta o promoción | Varchar(1) | A = Simple, M = Receta, P = Promoción |
| **Profile** |  Indica su el artículo es de venta o compra / venta | Varchar(1) | A = Compra / Venta, V = Venta |
| **GroupType** |  Si el artículo es del tipo P (promoción) este campo podrá indicar si la promoción es fija o variable | Varchar(1) | F = Fija, V = Variable |

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

**Información Response JSON GetSectionList**

| **Campo** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** | 
| --- | --- | --- |--- |
| **Code** | Es el código del rubro  | ENTERO_TG | 1 |
| **Description** | Descripción del rubro | Varchar(30) | Bebidas |

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
| **General** | E9999 | Error no esperado |

