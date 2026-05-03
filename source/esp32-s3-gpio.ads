--  ESP32-S3 specific GPIO constants.
--  This package narrows the generic ESP32.GPIO types to the concrete pin range
--  of the ESP32-S3 silicon and defines Safe_GPIO_Pin which additionally
--  excludes pins reserved for internal flash and PSRAM.
with Ada.Interrupts;
with ESP32.GPIO;

package ESP32.S3.GPIO is

   --  -----------------------------------------------------------------------
   --  Pin range for the ESP32-S3 (GPIO 0 .. 48, 49 total).
   --  -----------------------------------------------------------------------
   GPIO_Min_Pin : constant := 0;
   GPIO_Max_Pin : constant := 48;

   subtype GPIO_Pin is ESP32.GPIO.GPIO_Pin range GPIO_Min_Pin .. GPIO_Max_Pin;

   --  -----------------------------------------------------------------------
   --  Module-reserved pins.
   --  These ranges are typical for standard ESP32-S3 modules (e.g.
   --  ESP32-S3-WROOM-1, -N8R8).  A module with no Octal PSRAM may expose
   --  GPIO 33-37 as general-purpose pins ÃÂ¢ÃÂÃÂ in that case declare your own
   --  subtype that only excludes Flash_Pin_First .. Flash_Pin_Last.
   --
   --  GPIO 26-32 : internal SPI flash (SPI0 / SPI1)
   --  GPIO 33-37 : Octal PSRAM
   --  -----------------------------------------------------------------------
   Flash_Pin_First : constant := 26;
   Flash_Pin_Last  : constant := 32;

   PSRAM_Pin_First : constant := 33;
   PSRAM_Pin_Last  : constant := 37;

   --  Pins safe for general application use.  Violations are caught at
   --  compile time when the pin number is a static literal or named number.
   --  Flash and PSRAM ranges are checked independently so the predicate
   --  remains correct even if the two reserved regions are not contiguous.
   subtype Safe_GPIO_Pin is GPIO_Pin
   with
     Static_Predicate =>
       Safe_GPIO_Pin not in Flash_Pin_First .. Flash_Pin_Last
       and Safe_GPIO_Pin not in PSRAM_Pin_First .. PSRAM_Pin_Last;

   --  -----------------------------------------------------------------------
   --  Interrupt matrix source IDs (from
   --  esp-idf/components/soc/esp32s3/include/soc/interrupts.h).
   --  -----------------------------------------------------------------------
   Core_0_Interrupt_Source : constant Ada.Interrupts.Interrupt_ID := 16;
   Core_1_Interrupt_Source : constant Ada.Interrupts.Interrupt_ID := 18;

end ESP32.S3.GPIO;
