def encode_msg(request, data):
    if request == 'register':
        return f"{request}|{data}"
    elif request == 'choose':
        return f"{request}|{data}"
    elif request == 'user_files':
        data = "|".join(data)
        return f"{request}|{data}"
    elif request == 'get':
        data = "|".join(data)
        return f"{request}|{data}"


def decode_msg(data: str):
    request = data.split("|")[0]
    if request == 'register':
        return data.split("|")[0], data.split("|")[1]
    if request == 'choose':
        return data.split("|")[0], data.split("|")[1]
    if request == 'user_files':
        return data.split("|")[0], data.split("|")[1:]
    if request == 'get':
        return data.split("|")[0], data.split("|")[1:]
