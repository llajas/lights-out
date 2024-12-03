<?xml version="1.0" ?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:template match="@*|node()">
     <xsl:copy>
       <xsl:apply-templates select="@*|node()"/>
     </xsl:copy>
  </xsl:template>

  <xsl:template match="devices">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>

      <!-- Add USB 3.0 controller -->
      <controller type="usb" index="0" model="qemu-xhci" ports="15">
        <address type="pci" domain="0x0000" bus="0x00" slot="0x07" function="0x0"/>
      </controller>

      <!-- Pass through specific devices -->

      <!-- Realtek Ethernet Adapter -->
      <hostdev mode="subsystem" type="usb" managed="no">
        <source startupPolicy="optional">
          <vendor id="0x0bda"/>
          <product id="0x8153"/>
        </source>
        <address type="usb" bus="0" port="1"/>
      </hostdev>

      <!-- NetGear A6210 -->
      <hostdev mode="subsystem" type="usb" managed="no">
        <source startupPolicy="optional">
          <vendor id="0x0846"/>
          <product id="0x9053"/>
        </source>
        <address type="usb" bus="0" port="2"/>
      </hostdev>

      <!-- USB Hub Billboard Device -->
      <hostdev mode="subsystem" type="usb" managed="no">
        <source startupPolicy="optional">
          <vendor id="0x0835"/>
          <product id="0x2a01"/>
        </source>
        <address type="usb" bus="0" port="3"/>
      </hostdev>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>
