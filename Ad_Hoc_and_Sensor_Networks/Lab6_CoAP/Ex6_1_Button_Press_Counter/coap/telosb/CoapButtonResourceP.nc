#include <pdu.h>
#include <async.h>
#include <mem.h>
#include <resource.h>
#include <UserButton.h>
#include <Timer.h>

generic module CoapButtonResourceP(uint8_t uri_key) {
  provides interface CoapResource;
  //uses interface Leds;
  //uses interface Get<button_state_t>;
  uses interface Notify<button_state_t>;
  //uses interface Timer<TMilli>;
} implementation {

  coap_pdu_t *response;

  coap_pdu_t *temp_request;
  bool lock = FALSE; //TODO: atomic
  coap_async_state_t *temp_async_state = NULL;
  coap_resource_t *temp_resource = NULL;
  unsigned int temp_content_format;
  uint16_t button_press_count = 0;

  command error_t CoapResource.initResourceAttributes(coap_resource_t *r) {
    call Notify.enable();
    return SUCCESS;
  }

  /////////////////////
  // GET:
  task void getMethod() {

    int datalen = 0;
    char databuf[8]; //ASCII of uint8_t -> max 3 chars + \0

    //todo
    uint16_t val = button_press_count;
    datalen= snprintf(databuf, sizeof(databuf), "%i", val);

    response = coap_new_pdu();
    response->hdr->code = COAP_RESPONSE_CODE(205);

    if (temp_resource->data != NULL) {
      coap_free(temp_resource->data);
    }
    if ((temp_resource->data = (uint8_t *) coap_malloc(datalen)) != NULL) {
      memcpy(temp_resource->data, databuf, datalen);
      temp_resource->data_len = datalen;
    } else {
      response->hdr->code = COAP_RESPONSE_CODE(500);
    }

    signal CoapResource.methodDone(SUCCESS,
				   temp_async_state,
				   temp_request,
				   response,
				   temp_resource);
    lock = FALSE;
  }

  command int CoapResource.getMethod(coap_async_state_t* async_state,
				     coap_pdu_t* request,
				     coap_resource_t *resource,
				     unsigned int content_format) {
    if (lock == FALSE) {
      lock = TRUE;

      temp_async_state = async_state;
      temp_request = request;
      temp_resource = resource;
      temp_content_format = content_format;

      post getMethod();
      return COAP_SPLITPHASE;
    } else {
      return COAP_RESPONSE_503;
    }
  }

  /////////////////////
  // PUT:
  task void putMethod() {
    size_t size;
    char* data = "00000000";//init

    response = coap_new_pdu();

    coap_get_data(temp_request, &size, &data);
    //memcpy(temp_request, &size, data);

    // *data = *data - *(uint16_t *)"0";
    button_press_count = atol(data);

    response->hdr->code = COAP_RESPONSE_CODE(204);

    signal CoapResource.methodDone(SUCCESS,
				   temp_async_state,
				   temp_request,
				   response,
				   temp_resource);
    lock = FALSE;
  }

  command int CoapResource.putMethod(coap_async_state_t* async_state,
				     coap_pdu_t* request,
				     coap_resource_t *resource,
				     unsigned int content_format) {
    if (lock == FALSE) {
      lock = TRUE;

      temp_async_state = async_state;
      temp_request = request;
      temp_resource = resource;
      temp_content_format = content_format;

      post putMethod();
      return COAP_SPLITPHASE;
    } else {
      return COAP_RESPONSE_CODE(503);
    }
  }

  command int CoapResource.postMethod(coap_async_state_t* async_state,
				      coap_pdu_t* request,
				      coap_resource_t *resource,
				      unsigned int content_format) {
    return COAP_RESPONSE_405;
  }

  command int CoapResource.deleteMethod(coap_async_state_t* async_state,
					coap_pdu_t* request,
					coap_resource_t *resource) {
    return COAP_RESPONSE_405;
  }

  event void Notify.notify( button_state_t state ){
      if( state == BUTTON_PRESSED ){
        button_press_count++;
      }
  }

}
