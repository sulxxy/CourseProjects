#include <iprouting.h>

#include "tinyos_coap_resources.h"

configuration CoapServerC {

} implementation {
  components MainC;
  components UserButtonC;
  components LedsC;
  components CoapServerP;
  components LibCoapAdapterC;
  components IPStackC;

  CoapServerP.Boot -> MainC;

#ifdef COAP_SERVER_ENABLED
  components CoapUdpServerC;
  components new UdpSocketC() as UdpServerSocket;
  CoapServerP.CoAPServer -> CoapUdpServerC;
  CoapUdpServerC.LibCoapServer -> LibCoapAdapterC.LibCoapServer;
  LibCoapAdapterC.UDPServer -> UdpServerSocket;


#ifdef COAP_RESOURCE_BUTTON
  components new CoapButtonResourceC(INDEX_BUTTON) as CoapButtonResource;
  //CoapButtonResource.Leds -> LedsC;
  CoapButtonResource.Notify -> UserButtonC;
  CoapUdpServerC.CoapResource[INDEX_BUTTON]  -> CoapButtonResource.CoapResource;
#endif


#endif

  }
