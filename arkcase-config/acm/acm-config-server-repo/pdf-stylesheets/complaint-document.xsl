<?xml version="1.0" encoding="UTF-8"?>
<!-- =================================================== -->
<!-- XSL-FO stylesheet to generate Request in PDF format -->
<!-- =================================================== -->
<xsl:stylesheet version="2.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    exclude-result-prefixes="fo">
    <xsl:output method="xml" version="1.0"
        omit-xml-declaration="no" indent="yes" />

   
    <!-- ======================== -->
    <!-- root element: complaint -->
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
					<xsl:apply-templates select="complaint"/>
                    <fo:block font-size="16pt" text-align="center" font-weight="bold" space-after="0.25in">
                        Incident Information
                    </fo:block>
                    <fo:block font-size="13pt" text-align="center" space-after="0.75in">
                        <xsl:value-of select="complaint/incidentDate"/>
                    </fo:block>
                    <fo:block font-size="10pt" space-after="0.15in">
                        Initiator
						<fo:block font-weight="bold" border-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
							<xsl:value-of select="complaint/initiator"/>
						</fo:block>
                    </fo:block>
					<fo:block font-size="10pt" space-after="0.15in">
                        Complaint Title
						<fo:block font-weight="bold"  border-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
							<xsl:value-of select="complaint/complaintTitle"/>
						</fo:block>
                    </fo:block>
                    <fo:block font-size="10pt" space-after="0.15in">
                        Incident Category 
						<fo:block font-weight="bold" border-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
							<xsl:value-of select="complaint/complaintType"/>
						</fo:block>
                    </fo:block>
                    <fo:block font-size="10pt" space-after="0.15in">
                        Complaint Number
						<fo:block font-weight="bold"  border-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
							<xsl:value-of select="complaint/complaintNumber"/></fo:block>
                    </fo:block>
                    <fo:block font-size="10pt" space-after="0.15in">
                        Priority
						<fo:block font-weight="bold" border-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
							<xsl:value-of select="complaint/priority"/>
						</fo:block>
                    </fo:block>
					<fo:block font-size="10pt" space-after="0.15in">
                        Complaint Tag
						<fo:block font-weight="bold" border-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
							<xsl:value-of select="complaint/complaintTag"/></fo:block>
                    </fo:block>
					<fo:block font-size="10pt" space-after="0.15in">
                        Frequency
						<fo:block font-weight="bold" border-color="#badeff" border-style="solid" border-width=".4mm" height="12pt" padding="1mm">
							<xsl:value-of select="complaint/frequency"/>
						</fo:block>
                    </fo:block>
                    <fo:block font-size="10pt" space-after="0.15in">
                        Complaint Description
						<fo:block font-weight="bold" border-color="#badeff" border-style="solid" border-width=".4mm" padding="1mm">
							<xsl:value-of select="complaint/complaintDescription"/></fo:block>
                    </fo:block>
					<fo:block font-size="11pt" space-after="0.15in">
								Location
							   <fo:block>
									Type: <fo:inline font-weight="bold"><xsl:value-of select="complaint/locationType"/></fo:inline>
									Address: <fo:inline font-weight="bold"><xsl:value-of select="complaint/locationAddress"/></fo:inline>
									City:  <fo:inline font-weight="bold"><xsl:value-of select="complaint/locationCity"/></fo:inline>
									State:  <fo:inline font-weight="bold"><xsl:value-of select="complaint/locationState"/></fo:inline>
									Zip:  <fo:inline font-weight="bold"><xsl:value-of select="complaint/locationZip"/></fo:inline>
									Added by:  <fo:inline font-weight="bold"><xsl:value-of select="complaint/locationAddedBy"/></fo:inline>
								</fo:block>
	                  </fo:block>
					  <fo:block font-size="11pt" space-after="0.15in">
						  People
						  <fo:table border-color="#badeff" border-style="solid" border-width=".4mm" table-layout="fixed" width="100%">
							  <fo:table-column column-width="40%"/>
							  <fo:table-column column-width="60%"/>
							  <fo:table-body font-weight="normal" font-size="10pt">
								  <fo:table-row line-height="12pt">
									   <fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
			                                <fo:block font-weight="bold" text-align="center">Person Type</fo:block>
		                               </fo:table-cell>
									   <fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
		                               		<fo:block font-weight="bold" text-align="center">Person</fo:block>
			                            </fo:table-cell>
								   </fo:table-row>
								  <xsl:for-each select="complaint/people">
									  <xsl:for-each select="person">
										   <fo:table-row line-height="12pt" font-size="10pt">
											   <fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
					                                <fo:block text-align="center"><xsl:value-of select="personType"/></fo:block>
				                               </fo:table-cell>
											   <fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
				                               		<fo:block text-align="center"><xsl:value-of select="personName"/></fo:block>
					                            </fo:table-cell>
										   </fo:table-row>
									   </xsl:for-each>
							   </xsl:for-each>
						   </fo:table-body>
					      </fo:table>
					   </fo:block>
					   
					    <fo:block font-size="11pt" space-after="0.15in">
							Participants
						  <fo:table border-color="#badeff" border-style="solid" border-width=".4mm" table-layout="fixed" width="100%">
							  <fo:table-column column-width="40%"/>
							  <fo:table-column column-width="60%"/>
							  <fo:table-body font-weight="normal" font-size="10pt">
								  <fo:table-row line-height="12pt">
									   <fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
			                                <fo:block font-weight="bold" text-align="center">Participant Type</fo:block>
		                               </fo:table-cell>
									   <fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
		                               		<fo:block font-weight="bold" text-align="center">Participant</fo:block>
			                            </fo:table-cell>
								   </fo:table-row>
								  <xsl:for-each select="complaint/participants">
									  <xsl:for-each select="participant">
										   <fo:table-row line-height="12pt" font-size="10pt">
											   <fo:table-cell  border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
					                               <fo:block text-align="center"><xsl:value-of select="participantType"/></fo:block>
				                               </fo:table-cell>
											   <fo:table-cell border-width="1pt" border-color="#badeff" border-style="solid" padding="1mm">
				                               		<fo:block text-align="center"><xsl:value-of select="participantName"/></fo:block>
					                            </fo:table-cell>
										   </fo:table-row>
									   </xsl:for-each>
							   </xsl:for-each>
						   </fo:table-body>
					      </fo:table>
					   </fo:block>
                </fo:flow>
            </fo:page-sequence>

        </fo:root>
    </xsl:template>
</xsl:stylesheet>
