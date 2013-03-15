<?xml version="1.0" encoding="UTF-8"?>
<xs:schema xmlns="http://alicebot.org/2001/AIML-1.0.1" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:sch="http://www.ascc.net/xml/schematron"
	targetNamespace="http://alicebot.org/2001/AIML-1.0.1" elementFormDefault="qualified"
	attributeFormDefault="unqualified" version="1.0" xml:lang="EN">
	<xs:element name="aiml">
		<xs:annotation>
			<xs:documentation>An AIML object is represented by an aiml element in an XML document.</xs:documentation>
			<xs:appinfo>
				<sch:title>Schematron validation</sch:title>
				<sch:ns prefix="aiml" uri="http://alicebot.org/2001/AIML-1.0.1"/>
			</xs:appinfo>
		</xs:annotation>
		<xs:complexType>
			<xs:choice minOccurs="1" maxOccurs="unbounded">
				<xs:element name="topic">
					<xs:complexType>
						<xs:annotation>
							<xs:documentation>A topic is an optional top-level element that contains
								category elements. A topic element has a required name attribute
								that must contain a simple pattern expression. A topic element may
								contain one or more category elements.</xs:documentation>
						</xs:annotation>
						<xs:sequence maxOccurs="unbounded">
							<xs:element name="category" type="Category"/>
						</xs:sequence>
						<xs:attribute name="name" type="SimplePatternExpression" use="required"/>
					</xs:complexType>
				</xs:element>
				<xs:element name="category" type="Category"/>
			</xs:choice>
			<xs:attribute name="version" use="required">
				<xs:simpleType>
					<xs:restriction base="xs:string">
            <xs:enumeration value="1.0"/>
						<xs:enumeration value="1.0.1"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:attribute>
		</xs:complexType>
	</xs:element>
	<xs:complexType name="Category">
		<xs:annotation>
			<xs:documentation>A category is a top-level (or second-level, if contained within a
				topic) element that contains exactly one pattern and exactly one template. A
				category does not have any attributes. All category elements that do not occur as
				children of an explicit topic element must be assumed by the AIML interpreter to
				occur as children of an "implied" topic whose name attribute has the value * (single
				asterisk wildcard).</xs:documentation>
		</xs:annotation>
		<xs:sequence>
			<xs:element name="pattern" type="MixedPatternExpression">
				<xs:annotation>
					<xs:documentation>A pattern is an element whose content is a mixed pattern
						expression. Exactly one pattern must appear in each category. The pattern
						must always be the first child element of the category. A pattern does not
						have any attributes. The contents of the pattern are appended to the full
						match path that is constructed by the AIML interpreter at load
					time.</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="that" type="MixedPatternExpression" minOccurs="0">
				<xs:annotation>
					<xs:documentation>The pattern-side that element is a special type of pattern
						element used for context matching. The pattern-side that is optional in a
						category, but if it occurs it must occur no more than once, and must
						immediately follow the pattern and immediately precede the template. A
						pattern-side that element contains a simple pattern expression. The contents
						of the pattern-side that are appended to the full match path that is
						constructed by the AIML interpreter at load time. If a category does not
						contain a pattern-side that, the AIML interpreter must assume an "implied"
						pattern-side that containing the pattern expression * (single asterisk
						wildcard).</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="template" type="MixedTemplateContentContainer">
				<xs:annotation>
					<xs:documentation>The majority of AIML content is within the template. The
						template may contain zero or more AIML template elements mixed with
						character data.</xs:documentation>
				</xs:annotation>
			</xs:element>
		</xs:sequence>
	</xs:complexType>
	<xs:complexType name="MixedPatternExpression" mixed="true">
		<xs:annotation>
			<xs:documentation>A mixed pattern expression is composed from one or more mixed pattern
				expression constituents, separated by XML spaces (&amp;#x20).</xs:documentation>
		</xs:annotation>
		<xs:choice minOccurs="0" maxOccurs="unbounded">
			<xs:element name="bot" type="BotPredicate"/>
		</xs:choice>
	</xs:complexType>
	<xs:complexType name="MixedTemplateContentContainer" mixed="true">
		<xs:choice minOccurs="0" maxOccurs="unbounded">
			<xs:group ref="atomicElements"/>
			<xs:group ref="textFormattingElements"/>
			<xs:group ref="conditionalElements"/>
			<xs:group ref="captureElements"/>
			<xs:group ref="symbolicReductionElements"/>
			<xs:group ref="transformationalElements"/>
			<xs:group ref="covertElements"/>
			<xs:group ref="externalProcessorElements"/>
			<xs:any namespace="##other" processContents="lax"/>
		</xs:choice>
	</xs:complexType>
	<xs:group name="atomicElements">
		<xs:annotation>
			<xs:documentation>An atomic template element in AIML indicates to an AIML interpreter
				that it must return a value according to the functional meaning of the element.
				Atomic elements do not have any content.</xs:documentation>
		</xs:annotation>
		<xs:choice>
			<xs:element name="star" type="IndexedElement">
				<xs:annotation>
					<xs:documentation>The star element indicates that an AIML interpreter should
						substitute the value "captured" by a particular wildcard from the
						pattern-specified portion of the match path when returning the template. The
						star element has an optional integer index attribute that indicates which
						wildcard to use. The minimum acceptable value for the index is "1" (the
						first wildcard), and the maximum acceptable value is equal to the number of
						wildcards in the pattern. </xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="that" type="OneOrTwoDIndexedElement">
				<xs:annotation>
					<xs:documentation>The pattern-side that element is a special type of pattern
						element used for context matching. The pattern-side that is optional in a
						category, but if it occurs it must occur no more than once, and must
						immediately follow the pattern and immediately precede the template. A
						pattern-side that element contains a simple pattern expression. The contents
						of the pattern-side that are appended to the full match path that is
						constructed by the AIML interpreter at load time. If a category does not
						contain a pattern-side that, the AIML interpreter must assume an "implied"
						pattern-side that containing the pattern expression * (single asterisk
						wildcard). </xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="input" type="OneOrTwoDIndexedElement">
				<xs:annotation>
					<xs:documentation>The input element tells the AIML interpreter that it should
						substitute the contents of a previous user input. The template-side input
						has an optional index attribute that may contain either a single integer or
						a comma-separated pair of integers. The minimum value for either of the
						integers in the index is "1". The index tells the AIML interpreter which
						previous user input should be returned (first dimension), and optionally
						which "sentence" of the previous user input. The AIML interpreter should
						raise an error if either of the specified index dimensions is invalid at
						run-time. An unspecified index is the equivalent of "1,1". An unspecified
						second dimension of the index is the equivalent of specifying a "1" for the
						second dimension.</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="thatstar" type="IndexedElement">
				<xs:annotation>
					<xs:documentation>The thatstar element tells the AIML interpreter that it should
						substitute the contents of a wildcard from a pattern-side that element. The
						thatstar element has an optional integer index attribute that indicates
						which wildcard to use; the minimum acceptable value for the index is "1"
						(the first wildcard). An AIML interpreter should raise an error if the index
						attribute of a star specifies a wildcard that does not exist in the that
						element's pattern content. Not specifying the index is the same as
						specifying an index of "1".</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="topicstar" type="IndexedElement">
				<xs:annotation>
					<xs:documentation> The topicstar element tells the AIML interpreter that it
						should substitute the contents of a wildcard from the current topic (if the
						topic contains any wildcards). The topicstar element has an optional integer
						index attribute that indicates which wildcard to use; the minimum acceptable
						value for the index is "1" (the first wildcard). Not specifying the index is
						the same as specifying an index of "1".</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="get">
				<xs:annotation>
					<xs:documentation> The get element tells the AIML interpreter that it should
						substitute the contents of a predicate, if that predicate has a value
						defined. If the predicate has no value defined, the AIML interpreter should
						substitute the empty string "". The AIML interpreter implementation may
						optionally provide a mechanism that allows the AIML author to designate
						default values for certain predicates.</xs:documentation>
				</xs:annotation>
				<xs:complexType>
					<xs:attribute name="name" type="PredicateName"/>
				</xs:complexType>
			</xs:element>
			<xs:element name="bot" type="BotPredicate"/>
			<xs:group ref="shortcutElements"/>
			<xs:group ref="systemDefinedPredicates"/>
		</xs:choice>
	</xs:group>
	<xs:complexType name="BotPredicate">
		<xs:annotation>
			<xs:documentation> An element called bot, which may be considered a restricted
				version of get, is used to tell the AIML interpreter that it should
				substitute the contents of a "bot predicate". The value of a bot predicate
				is set at load-time, and cannot be changed at run-time. The AIML interpreter
				may decide how to set the values of bot predicate at load-time. If the bot
				predicate has no value defined, the AIML interpreter should substitute an
				empty string.</xs:documentation>
		</xs:annotation>
		<xs:attribute name="name" type="PredicateName" use="required"/>
	</xs:complexType>
	<xs:group name="shortcutElements">
		<xs:annotation>
			<xs:documentation>Several atomic AIML elements are "short-cuts" for combinations of
				other AIML elements.</xs:documentation>
		</xs:annotation>
		<xs:choice>
			<xs:element name="sr">
				<xs:annotation>
					<xs:documentation>The sr element is a shortcut for:
						&lt;srai&gt;&lt;star/&gt;&lt;/srai&gt; The atomic sr
						does not have any content. </xs:documentation>
				</xs:annotation>
			</xs:element>
		</xs:choice>
	</xs:group>
	<xs:group name="systemDefinedPredicates">
		<xs:annotation>
			<xs:documentation>Several atomic AIML elements require the AIML interpreter to
				substitute a value that is determined from the system, independently of the AIML
				content.</xs:documentation>
		</xs:annotation>
		<xs:choice>
			<xs:element name="date">
				<xs:annotation>
					<xs:documentation> The date element tells the AIML interpreter that it should
						substitute the system local date and time. No formatting constraints on the
						output are specified.</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="id">
				<xs:annotation>
					<xs:documentation>The id element tells the AIML interpreter that it should
						substitute the user ID. The determination of the user ID is not specified,
						since it will vary by application. A suggested default return value is
						"localhost".</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="size">
				<xs:annotation>
					<xs:documentation>The size element tells the AIML interpreter that it should
						substitute the number of categories currently loaded.</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="version">
				<xs:annotation>
					<xs:documentation>The version element tells the AIML interpreter that it should
						substitute the version number of the AIML interpreter.</xs:documentation>
				</xs:annotation>
			</xs:element>
		</xs:choice>
	</xs:group>
	<xs:group name="textFormattingElements">
		<xs:annotation>
			<xs:documentation>Text-formatting elements instruct an AIML interpreter to perform
				locale-specific post-processing of the textual results of the processing of their
				contents.</xs:documentation>
		</xs:annotation>
		<xs:choice>
			<xs:element name="uppercase" type="MixedTemplateContentContainer"/>
			<xs:element name="lowercase" type="MixedTemplateContentContainer"/>
			<xs:element name="formal" type="MixedTemplateContentContainer"/>
			<xs:element name="sentence" type="MixedTemplateContentContainer"/>
		</xs:choice>
	</xs:group>
	<xs:group name="conditionalElements">
		<xs:choice>
			<xs:element name="condition">
				<xs:annotation>
					<xs:documentation>The condition element instructs the AIML interpreter to return
						specified contents depending upon the results of matching a predicate
						against a pattern. NOTE: The definition in this Schema is currently far too
						permissive. AIML conditions have several forms and constraints that can't be
						expressed using W3C Schema alone. For this reason, AIML objects that
						validate using this Schema alone may not actually be valid AIML.</xs:documentation>
					<xs:appinfo>
						<sch:pattern name="valid condition type">
							<sch:rule context="aiml:condition">
								<sch:assert
									test="(@name and @value and not(aiml:li)) or                                 (@name and not(@value) and aiml:li[@value and not(@name)] and not(aiml:li[@name]) and count(aiml:li[not(@value) and not(@name)]) &lt;= 1) or                                 (not(@name) and not(@value) and aiml:li[@name and @value] and not(aiml:li[(@name and not(@value)) or (@value and not(@name))]) and count(aiml:li[not(@value) and not(@name)]) &lt;= 1)"
									> A condition must be a block condition, a single-predicate
									condition, or a multi-predicate condition. </sch:assert>
							</sch:rule>
						</sch:pattern>
					</xs:appinfo>
				</xs:annotation>
				<xs:complexType mixed="true">
					<xs:sequence minOccurs="0" maxOccurs="unbounded">
						<xs:any namespace="##any" processContents="lax"/>
					</xs:sequence>
					<xs:attribute name="name" type="PredicateName"/>
					<xs:attribute name="value" type="SimplePatternExpression"/>
				</xs:complexType>
			</xs:element>
			<xs:element name="random">
				<xs:annotation>
					<xs:documentation>The random element instructs the AIML interpreter to return
						exactly one of its contained li elements randomly.</xs:documentation>
				</xs:annotation>
				<xs:complexType>
					<xs:sequence>
						<xs:element name="li" type="MixedTemplateContentContainer"
							maxOccurs="unbounded"/>
					</xs:sequence>
				</xs:complexType>
			</xs:element>
		</xs:choice>
	</xs:group>
	<xs:group name="captureElements">
		<xs:annotation>
			<xs:documentation>AIML defines two content-capturing elements, which tell the AIML
				interpreter to capture their processed contents and perform some storage operation
				with them.</xs:documentation>
		</xs:annotation>
		<xs:choice>
			<xs:element name="set">
				<xs:annotation>
					<xs:documentation>The set element instructs the AIML interpreter to set the
						value of a predicate to the result of processing the contents of the set
						element. The set element has a required attribute name, which must be a
						valid AIML predicate name. If the predicate has not yet been defined, the
						AIML interpreter should define it in memory.</xs:documentation>
				</xs:annotation>
				<xs:complexType>
					<xs:complexContent>
						<xs:extension base="MixedTemplateContentContainer">
							<xs:attribute name="name" type="PredicateName"/>
						</xs:extension>
					</xs:complexContent>
				</xs:complexType>
			</xs:element>
			<xs:element name="gossip" type="MixedTemplateContentContainer">
				<xs:annotation>
					<xs:documentation> The gossip element instructs the AIML interpreter to capture
						the result of processing the contents of the gossip elements and to store
						these contents in a manner left up to the implementation. Most common uses
						of gossip have been to store captured contents in a separate
					file.</xs:documentation>
				</xs:annotation>
			</xs:element>
		</xs:choice>
	</xs:group>
	<xs:group name="symbolicReductionElements">
		<xs:choice>
			<xs:element name="srai" type="MixedTemplateContentContainer">
				<xs:annotation>
					<xs:documentation> The srai element instructs the AIML interpreter to pass the
						result of processing the contents of the srai element to the AIML matching
						loop, as if the input had been produced by the user (this includes stepping
						through the entire input normalization process).</xs:documentation>
				</xs:annotation>
			</xs:element>
		</xs:choice>
	</xs:group>
	<xs:group name="transformationalElements">
		<xs:choice>
			<xs:element name="person" type="MixedTemplateContentContainer">
				<xs:annotation>
					<xs:documentation>The person element instructs the AIML interpreter to: 1.
						replace words with first-person aspect in the result of processing the
						contents of the person element with words with the
						grammatically-corresponding third-person aspect; and 2. replace words with
						third-person aspect in the result of processing the contents of the person
						element with words with the grammatically-corresponding first-person aspect.
						The definition of "grammatically-corresponding" is left up to the
						implementation.</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="person2" type="MixedTemplateContentContainer">
				<xs:annotation>
					<xs:documentation>The person2 element instructs the AIML interpreter to: 1.
						replace words with first-person aspect in the result of processing the
						contents of the person2 element with words with the
						grammatically-corresponding second-person aspect; and 2. replace words with
						second-person aspect in the result of processing the contents of the person2
						element with words with the grammatically-corresponding first-person aspect.
						The definition of "grammatically-corresponding" is left up to the
						implementation.</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="gender" type="MixedTemplateContentContainer">
				<xs:annotation>
					<xs:documentation>The gender element instructs the AIML interpreter to: 1.
						replace male-gendered words in the result of processing the contents of the
						gender element with the grammatically-corresponding female-gendered words;
						and 2. replace female-gendered words in the result of processing the
						contents of the gender element with the grammatically-corresponding
						male-gendered words. The definition of "grammatically-corresponding" is left
						up to the implementation. Historically, implementations of gender have
						exclusively dealt with pronouns, likely due to the fact that most AIML has
						been written in English. However, the decision about whether to transform
						gender of other words is left up to the implementation.</xs:documentation>
				</xs:annotation>
			</xs:element>
		</xs:choice>
	</xs:group>
	<xs:group name="covertElements">
		<xs:annotation>
			<xs:documentation>AIML defines two "covert" elements that instruct the AIML interpreter
				to perform some processing on their contents, but to not return any
			value.</xs:documentation>
		</xs:annotation>
		<xs:choice>
			<xs:element name="think" type="MixedTemplateContentContainer">
				<xs:annotation>
					<xs:documentation>The think element instructs the AIML interpreter to perform
						all usual processing of its contents, but to not return any value,
						regardless of whether the contents produce output.</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="learn">
				<xs:simpleType>
					<xs:annotation>
						<xs:documentation>The learn element instructs the AIML interpreter to
							retrieve a resource specified by a URI, and to process its AIML object
							contents.</xs:documentation>
					</xs:annotation>
					<xs:restriction base="xs:anyURI"/>
				</xs:simpleType>
			</xs:element>
		</xs:choice>
	</xs:group>
	<xs:group name="externalProcessorElements">
		<xs:annotation>
			<xs:documentation>AIML defines two external processor elements, which instruct the AIML
				interpreter to pass the contents of the elements to an external processor. External
				processor elements may return a value, but are not required to do so. Contents of
				external processor elements may consist of character data as well as AIML template
				elements. If AIML template elements in the contents of an external processor element
				are not enclosed as CDATA, then the AIML interpreter is required to substitute the
				results of processing those elements before passing the contents to the external
				processor. AIML does not require that any contents of an external processor element
				are enclosed as CDATA. An AIML interpreter should assume that any unrecognized
				content is character data, and simply pass it to the appropriate external processor
				as-is, following any processing of AIML template elements not enclosed as CDATA. If
				an external processor is not available to process the contents of an external
				processor element, the AIML interpreter may return an error, but this is not
				required.</xs:documentation>
		</xs:annotation>
		<xs:choice>
			<xs:element name="system" type="MixedTemplateContentContainer">
				<xs:annotation>
					<xs:documentation>The system element instructs the AIML interpreter to pass its
						content (with any appropriate preprocessing) to the system command
						interpreter of the local machine on which the AIML interpreter is
					running.</xs:documentation>
				</xs:annotation>
			</xs:element>
			<xs:element name="javascript" type="MixedTemplateContentContainer">
				<xs:annotation>
					<xs:documentation>The javascript element instructs the AIML interpreter to pass
						its content (with any appropriate preprocessing, as noted above) to a
						server-side JavaScript interpreter on the local machine on which the AIML
						interpreter is running. The javascript element does not have any attributes.
						AIML does not require that an AIML interpreter include a server-side
						JavaScript interpreter, and does not require any particular behavior from
						the server-side JavaScript interpreter if it exists. The javascript element
						may return a value.</xs:documentation>
				</xs:annotation>
			</xs:element>
		</xs:choice>
	</xs:group>
	<xs:complexType name="OneOrTwoDIndexedElement">
		<xs:attribute name="index">
			<xs:simpleType>
				<xs:restriction base="xs:string">
					<xs:minLength value="1"/>
					<xs:pattern value="\d+|\d+,\d+"/>
				</xs:restriction>
			</xs:simpleType>
		</xs:attribute>
	</xs:complexType>
	<xs:complexType name="IndexedElement">
		<xs:attribute name="index" type="xs:integer"/>
	</xs:complexType>
	<xs:simpleType name="PredicateName">
		<xs:restriction base="xs:string">
			<xs:pattern value="\c+"/>
		</xs:restriction>
	</xs:simpleType>
</xs:schema>
