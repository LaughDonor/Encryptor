<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:strip-space elements="*" />
	<xsl:output method="xml" indent="yes" />
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template> 
	<xsl:template match="References">
		<References>
			<xsl:apply-templates select="@* | *"/>
			<Signature xmlns="http://www.w3.org/2000/09/xmldsig#">
				<SignedInfo>
					<CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />
					<SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" />
					<Reference URI="">
						<Transforms>
							<Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature" />
						</Transforms>
						<DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" />
						<DigestValue />
					</Reference>
				</SignedInfo>
				<SignatureValue />
				<KeyInfo>
					<KeyValue />
				</KeyInfo>
			</Signature>
		</References>
	</xsl:template>
</xsl:stylesheet>