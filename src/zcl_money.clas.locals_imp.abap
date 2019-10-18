CLASS lcx_money_error DEFINITION INHERITING FROM cx_no_check.
  PUBLIC SECTION.
    METHODS:
      constructor IMPORTING text TYPE string,
      get_text REDEFINITION.
  PRIVATE SECTION.
    DATA:
      text TYPE string.
ENDCLASS.

CLASS lcx_money_error IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    me->text = text.
  ENDMETHOD.

  METHOD get_text.
    result = text.
  ENDMETHOD.
ENDCLASS.
