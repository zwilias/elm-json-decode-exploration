var _user$project$Native_Json = (function () {
    function intDecoder(value) {
        if (typeof value !== 'number') {
			return badPrimitive('an Int', value);
		}

		if (
            -2147483647 < value
            && value < 2147483647
            && (value | 0) === value
        ) {
			return ok(value);
		}

		if (
            isFinite(value)
            && !(value % 1)
        ) {
			return ok(value);
		}

		return badPrimitive('an Int', value);
    };

    function boolDecoder(value) {
        return (typeof value === 'boolean')
			? ok(value)
			: badPrimitive('a Bool', value);
    }

    function floatDecoder(value) {
        return (typeof value === 'number')
			? ok(value)
			: badPrimitive('a Float', value);
    }

    function stringDecoder(value) {
        return (typeof value === 'string')
			? ok(value)
			: (value instanceof String)
				? ok(value + '')
				: badPrimitive('a String', value);
    }

    function nullDecoder(result, value) {
        return (value === null)
			? ok(result)
			: badPrimitive('null', value);
    }

    function listDecoder(entryDecoder, value) {
        if (!(value instanceof Array)) {
            return badPrimitive('a List', value);
        }

        var list = _elm_lang$core$Native_List.Nil;

		for (var i = value.length; i--; )
		{
			var result = entryDecoder(value[i]);

			if (result.ctor !== 'Ok')
			{
				return badIndex(i, result._0);
			}

			list = _elm_lang$core$Native_List.Cons(result._0, list);
		}

		return ok(list);
    }

    function field(name, decoder, value) {
		if (typeof value !== 'object' || value === null || !(name in value))
		{
			return badPrimitive('an object with a field named `' + name + '`', value);
		}

		return decoder(value[name]);
    }

    function oneOf(decoders, value) {
        var errors = [];
        var decoder = decoders;
        while (decoder.ctor !== '[]') {
            var result = decoder._0(value);

            if (result.ctor === 'Ok') {
                return result;
            }

            errors.push(result._0);
            decoder = decoder._1;
        }

        return badOneOf(errors);
    }

    function constantDecoder(result, value) {
        return ok(result);
    }


    function ok(val) {
        return _elm_lang$core$Result$Ok(val);
    }

    function err(val) {
        return _elm_lang$core$Result$Err(val);
    }

    function badOneOf(errors) {
        if (errors.length == 0) {
            return err('oneOf with empty list');
        }

        return err(
            'oneOf failed to find successful decoder: '
            + errors.join("; ")
        );
    }

    function badIndex(index, errMsg) {
        return err(
            'Encountered error at index '
            + index
            + ": "
            + errMsg
        );
    }

    function badPrimitive(expected, actual) {
        return err(
            'Expected '
            + expected
            + ' but instead got: '
            + jsToString(actual)
        );
    }


    function jsToString(value)
    {
    	return value === undefined
    		? 'undefined'
    		: JSON.stringify(value);
    }


    return {
        intDecoder: intDecoder,
        boolDecoder: boolDecoder,
        floatDecoder : floatDecoder,
        stringDecoder: stringDecoder,
        nullDecoder: F2(nullDecoder),
        listDecoder: F2(listDecoder),
        constantDecoder: F2(constantDecoder),
        oneOf: F2(oneOf),
        field: F3(field)
    };
})();
