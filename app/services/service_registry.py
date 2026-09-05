SERVICES = [
    {
        "name": "deployops-api",
        "type": "api",
        "status": "healthy",
    },
    {
        "name": "deployops-worker",
        "type": "worker",
        "status": "healthy",
    },
]


def get_services():
    return SERVICES
