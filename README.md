# Resto Apertura Comandas (Mostrador y Delivery)

La API permite registrar en la base de datos de Tango Restó, las comandas o pedidos generados por aplicaciones externas. Esta información es recibida como parámetros de entrada y la comanda será visualiza en el módulo de Delivery o Mostrador según sea el caso.

Desde Restô se podrá:
  - Identificar el origen de la comanda. 
  - Cancelar una comanda.
  - Crear un cliente si no existe siendo la dirección de entrega la que indique un método para agregar una comanda.


## Arquitectura

![imagenapi](https://github.com/TangoSoftware/RestoAperturaComandasMostradorDelivery/blob/master/00.jpg)

## Métodos

### 1. AddOrder (POS)
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

| **Campo** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** |
| --- | --- | --- | --- |
| **CashCode** | Código del puesto de caja asigando a la comanda | Integer(8) | 1 |

<br/><br/>

**Información Order**

| **Campo** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** |
| --- | --- | --- | --- |
| **ExternalId** | Número de la orden externa | Integer(8) | 3000 |
| **platformId** | Número de la orden externa | D_ID(4) | 3 |
| **RegisteredDate** | Fecha de registro de la orden | Date | mm/dd/aaaa |
| **DeliveryDate** | Fecha estimada de entrega de la comanda | Date | mm/dd/aaaa |
| **PickUp** | La comanda será vista desde delivery o mostrador | Varchar(10) | True = Delivery o False = Mostrador |
| **PickupDate** | Fecha registro de entrega de la comanda | Date | mm/dd/aaaa |
|  **Notes** | Nota para la comanda | Varchar(-1) | Colocar servilletas extras |
|  **PriceListCode** | Número de la lista de precio asicada a la comanda | ENTERO_TG | 1 |

<br/><br/>

**Información Customer**

| **Campo** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** |
| --- | --- | --- | --- |
|  **Name** | Nombre y apellido del cliente | Varchar(500 | Juan Martinez |
|  **Email** | Correo electrónico del cliente | Varchar(500 | juanmartinez@ejemplo.com |

<br/><br/>

**Información Address**

| **Campo** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** |
| --- | --- | --- | --- |
|  **Description** | Descripción de la dirección del cliente | Varchar(500 | Dirección Principal |
|  **Phome** | Número telefónico del cliente | Varchar(200 | 54113426578 |
|  **Notes** | Nota para la dirección del cliente | Varchar(-1) | Puerta de madera |
|  **ZipCode** | Código postal de la dirección del cliente | Varchar(40) | 1019 |
|  **City** | Ciudad | Varchar(500) | Capital Federal |
|  **Street** | Nombre de la calle de la dirección del cliente| Varchar(500) | Esmeralda |
|  **Number** | Número o altura de la calle de la dirección del cliente | Varchar(40) | 1120 |
|  **Area** | localidad de la dirección del cliente | Varchar(500) | Retiro |
|  **Corner** | Esquina referencial a la calle de la dirección del cliente | Varchar(500) | Corriente |
|  **Complement** | Identificación del número del Piso de la dirección del cliente | Varchar(500) | PB |
|  **Department** | Identificación del departamento de la dirección del cliente | Varchar(500) | 5A |

<br/><br/>

**Información Details**

| **Campo** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** |
| --- | --- | --- | --- |
|  **Code** | Codigo del artículo  | Varchar(15) | AC001 |
|  **Quantity** | Cantidad del artículo | Integer(4) | 2 |
|  **UnitPrice** | Precio unitario del artículo  | DECIMAL_TG | 200.0 |
|  **Notes** | Nota para el artículo | Varchar(-1) | Sin sal |

<br/><br/>

**Información OptionGroups**

| **Campo** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** |
| --- | --- | --- | --- |
|  **IntegrationCode** | Código del artículo que forma parte de una promoción en el detalle de la comanda | Varchar(15) | GAS009 |
|  **Quantity** | Cantidad del artículo que forma parte del artículo promoción | Integer(4) | 1 |
|  **Amount** | Precio unitario del artículo que fomra parte de la promoción  | DECIMAL_TG | 20.0 |

<br/><br/>

**Información Discount**

| **Campo** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** |
| --- | --- | --- | --- |
|  **Type** | Indica si el valor del descuento a aplicar será en porcentaje o en importe  | Varchar(1) | I = Importe o P = Porcentaje |
|  **Amount** | Valor a aplocar del descuento  | DECIMAL_TG | 20 |
|  **Code** | Representa el código de la cuenta de caja  | Varchar(15) | 1 |

<br/><br/>

**Información Payments**

| **Campo** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** |
| --- | --- | --- | --- |
|  **PaymentAmount** | Representa el monto abonado con la cuenta de caja  | DECIMAL_TG | 20 |
| **Online** | Permite visualiar en la comanda la cuenta de caja que ya tiene asociada al momento de abonar la comanda | Varchar(10) | True  |

