#include <UserButton.h>
generic configuration CoapButtonResourceC(uint8_t uri_key) {
    provides interface CoapResource;
    //uses interface Leds;
    uses interface Notify<button_state_t>;
} implementation {
    components new CoapButtonResourceP(uri_key) as CoapLedResourceP;

    CoapResource = CoapLedResourceP;
    //Leds = CoapLedResourceP.Leds;

    Notify = CoapLedResourceP.Notify;
}
