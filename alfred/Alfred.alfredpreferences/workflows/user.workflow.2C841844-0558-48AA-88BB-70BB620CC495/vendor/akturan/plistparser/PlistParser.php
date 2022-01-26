<?php

class PlistParser
{
	private $skipTextNodes = "#text";
	private $methodPrefix = "parse";

	const PARSE_INTEGER = "parseInteger",
		  PARSE_STRING = "parseString",
		  PARSE_DATE = "parseDate",
	      PARSE_TRUE = "parseTrue",
		  PARSE_FALSE = "parseFalse",
	      PARSE_DICT = "parseDict",
	      PARSE_ARRAY = "parseArray"
	;

	public function plistToArray( $file )
	{
		if (!file_exists($file))
		{
			throw new Exception("Unable to open file");
		}

		$plistDocument = new DOMDocument();
		$plistDocument->load($file);

		$result = $this->parsePlist($plistDocument);

		return $result;
	}

	public function searchKeyInPlist( $file, $key )
	{
		$result = $this->plistToArray($file);

		if ($result){
			if (array_key_exists($key, $result))
			{
				return $result[$key];
			}
		}

		return null;
	}

	private function parseValue( $valueNode )
	{
		$valueType = $valueNode->nodeName;
		$methodName = $this->getTransformerName($valueType);

		if ( method_exists($this, $methodName) ) {
			return $this->{$methodName}($valueNode);
		}

		return $this->getNodeContentWithNodeAndMethod($valueNode, $methodName);
	}

	private function getNodeContentWithNodeAndMethod($node, $method)
	{
		$result = null;
		switch ($method)
		{
			case self::PARSE_INTEGER :
				$result = $node->textContent;
				break;

			case self::PARSE_STRING :
				$result = $node->textContent;
				break;

			case self::PARSE_DATE :
				$result = $node->textContent;
				break;

			case self::PARSE_TRUE :
				$result = true;
				break;

			case self::PARSE_FALSE :
				$result = false;
				break;

			case self::PARSE_DICT :
				$result = $this->parseDict($node);
				break;

			case self::PARSE_ARRAY :
				$result = $this->parseArray($node);
				break;

			default:
				break;
		}

		return $result;
	}

	private function getTransformerName($type)
	{
		return $this->methodPrefix. ucfirst( $type );
	}

	private function parseDict( $dictNode )
	{
		$dict = array();

		for ($node = $dictNode->firstChild;	$node != null; $node = $node->nextSibling)
		{
			if ( $node->nodeName == "key" )
			{
				$key = $node->textContent;
				$valueNode = $node->nextSibling;

				while ( $valueNode->nodeType == XML_TEXT_NODE )
				{
					$valueNode = $valueNode->nextSibling;
				}

				$value = $this->parseValue($valueNode);
				$dict[$key] = $value;
			}
		}

		return $dict;
	}

	private function parseArray( $arrayNode )
	{
		$array = array();

		for ($node = $arrayNode->firstChild; $node != null; $node = $node->nextSibling)
		{
			if ( $node->nodeType == XML_ELEMENT_NODE )
			{
				array_push($array, $this->parseValue($node));
			}
		}

		return $array;
	}

	private function parsePlist($document)
	{
		$plistNode = $document->documentElement;

		$root = $plistNode->firstChild;
		while ( $root->nodeName == $this->skipTextNodes)
		{
			$root = $root->nextSibling;
		}

		return $this->parseValue($root);
	}

}