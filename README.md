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



**Información Addorder**

| **Campo** | **Descripción** | **Tipo de Dato** | **Valores Posibles / Ejemplos** |
| --- | --- | --- | --- |
| **CashCode** | Código del puesto de caja asigando a la comanda | Integer(8) | 1 |
| **ExternalId** | Número de la orden externa | Integer(8) | 3000 |
| **platformId** | Número de la orden externa | D_ID(4) | 3 |
| **RegisteredDate** | Fecha de registro de la orden | Date | dd/mm/aaaa |
| **DeliveryDate** | Fecha estimada de entrega de la comanda | Date | dd/mm/aaaa |
| **PickUp** | La comanda será vista desde delivery o mostrador | Varchar(10) | True = Delivery o False = Mostrador |
| **PickupDate** | Fecha registro de entrega de la comanda | Date | dd/mm/aaaa |
|  **Notes** | Nota para la comanda | Varchar(-1) | dd/mm/aaaa |
|  **PriceListCode** | Número de la lista de precio asicada a la comanda | ENTERO_TG | 1 |
|  **Name** | Nombre y apellido del cliente | Varchar(500 | Juan Martinez |
|  **Email** | Correo electrónico del cliente | Varchar(500 | juanmartinez@ejemplo.com |
|  **Description** | Descripción de la dirección del cliente | Varchar(500 | Dirección Principal |

 
