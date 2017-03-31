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

    function ok(val) {
        return _elm_lang$core$Result$Ok(val);
    }

    function badPrimitive(expected, actual) {
        return _elm_lang$core$Result$Err(
            'Fail - expected '
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
        intDecoder: intDecoder
    };
})();
