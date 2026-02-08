<?xml version="1.0" encoding="UTF-8"?>
<!-- =================================================== -->
<!-- XSL-FO stylesheet to generate Billing Invoice in PDF format -->
<!-- =================================================== -->
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    exclude-result-prefixes="fo">
    <xsl:output method="xml" version="1.0"
        omit-xml-declaration="no" indent="yes" />

   
    <!-- ======================== -->
    <!-- root element: billing-invoice -->
    <!-- ======================== -->
    <xsl:template match="/">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
            <fo:layout-master-set>
                <fo:simple-page-master
                    master-name="letter" page-height="11.0in"
                    page-width="8.5in" margin-top="0.17in"
                    margin-bottom="0.17in" margin-left="1.0in"
                    margin-right="1.0in">
                    <fo:region-body margin-top="0.5in"
                        margin-bottom="0.5in" />
                </fo:simple-page-master>
            </fo:layout-master-set>

            <fo:page-sequence master-reference="letter">

                <!-- output data goes here -->
                <fo:flow flow-name="xsl-region-body" font-family="'Lucida Grande',Tahoma,Arial,sans-serif">
					<xsl:apply-templates select="billing-invoice"/>
                    <fo:block font-size="16pt" text-align="right" font-weight="bold" space-after="0.25in">
                        Invoice
                    </fo:block>
                    <fo:block font-size="10pt" text-align="right" space-after="0.15in">
                        Date:
						<fo:inline font-weight="bold">
							<xsl:value-of select="billing-invoice/invoiceDate"/>
						</fo:inline>
                    </fo:block>
                    <fo:block font-size="10pt" text-align="right" space-after="0.15in">
                        Invoice #:
						<fo:inline font-weight="bold">
							<xsl:value-of select="billing-invoice/invoiceNumber"/>
						</fo:inline>
                    </fo:block>
                    <fo:block font-size="10pt" text-align="right" space-after="0.15in">
                        Requester Name:
						<fo:inline font-weight="bold">
							<xsl:value-of select="billing-invoice/requesterName"/>
						</fo:inline>
                    </fo:block>
                    <fo:block font-size="10pt" text-align="left" font-weight="bold" space-after="0.15in">
                        Bill To:
                    </fo:block>
                    <fo:block font-size="10pt" text-align="left" font-weight="bold" space-after="0.15in">
					    <xsl:value-of select="billing-invoice/requesterName"/>
                    </fo:block>
                    <fo:block font-size="10pt" text-align="left" font-weight="bold" space-after="0.55in">
					    <xsl:value-of select="billing-invoice/requesterAddress"/>
                    </fo:block>
                    <fo:block font-size="11pt" space-after="0.95in">
                      <fo:table border-color="#badeff" border-style="solid" border-width=".4mm" table-layout="fixed" width="100%">
                          <fo:table-column column-width="20%"/>
                          <fo:table-column column-width="50%"/>
                          <fo:table-column column-width="30%"/>
                          <fo:table-body font-weight="normal" font-size="12pt">
                              <fo:table-row line-height="12pt">
                                   <fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
                                        <fo:block text-align="center">Item #</fo:block>
                                   </fo:table-cell>
                                   <fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
                                        <fo:block text-align="center">Description</fo:block>
                                    </fo:table-cell>
                                   <fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
                                        <fo:block text-align="right">Amount</fo:block>
                                    </fo:table-cell>
                              </fo:table-row>
                              <xsl:for-each select="billing-invoice/billing-items">
                                  <xsl:for-each select="billing-item">
                                       <fo:table-row line-height="12pt" font-size="10pt">
                                           <fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
                                                <fo:block text-align="center"><xsl:value-of select="itemNumber"/></fo:block>
                                           </fo:table-cell>
                                           <fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
                                                <fo:block text-align="center"><xsl:value-of select="itemDescription"/></fo:block>
                                           </fo:table-cell>
                                           <fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
                                                <fo:block text-align="right"><xsl:value-of select="itemAmount"/></fo:block>
                                           </fo:table-cell>
                                       </fo:table-row>
                                   </xsl:for-each>
                              </xsl:for-each>
                              <fo:table-row line-height="12pt" font-size="10pt">
                                   <fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
                                        <fo:block text-align="center"></fo:block>
                                   </fo:table-cell>
                                   <fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
                                        <fo:block text-align="right" font-weight="bold">Total:</fo:block>
                                    </fo:table-cell>
                                   <fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
                                        <fo:block text-align="right" font-weight="bold"><xsl:value-of select="billing-invoice/totalAmount"/></fo:block>
                                    </fo:table-cell>
                              </fo:table-row>
                       </fo:table-body>
                      </fo:table>
                    </fo:block>
                    <fo:block font-size="10pt" text-align="left" font-weight="bold" space-after="0.15in">
                        Thanks,
                    </fo:block>
                    <fo:block font-size="10pt" text-align="left" font-weight="bold" space-after="0.15in">
                        Office Staff
                    </fo:block>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template>
</xsl:stylesheet>
