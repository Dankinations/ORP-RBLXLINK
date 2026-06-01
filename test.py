import asyncio
import websockets

connected_clients = set()

async def handler(websocket):
    print("Roblox has connected!")
    connected_clients.add(websocket)
    try:
        async for message in websocket:
            print(f"Received from Roblox: {message}")
    finally:
        connected_clients.remove(websocket)
        print("Roblox disconnected.")

async def send_to_roblox(message):
    if not connected_clients:
        print("No clients connected!")
        return
    
    for client in connected_clients:
        await client.send(message)
        print(f"Sent to Roblox: {message}")

async def main():
    async with websockets.serve(handler, "127.0.0.1", 2763):
        print("Server running. Type messages below to send to Roblox:")
        
        loop = asyncio.get_event_loop()
        while True:
            msg = await loop.run_in_executor(None, input, "> ")
            await send_to_roblox(msg)

if __name__ == "__main__":
    asyncio.run(main())