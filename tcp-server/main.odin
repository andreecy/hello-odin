package main

import "core:fmt"
import "core:net"
import "core:strings"

main :: proc() {
	listen_socket, err := net.listen_tcp(net.Endpoint{address = net.IP4_Loopback, port = 8080})
	if err != nil {
		fmt.println("Error listening on port 8080")
	}

	fmt.println("Listening on port 8080")

	client_socket, client_endpoint, accept_err := net.accept_tcp(listen_socket)

	if accept_err != nil {
		fmt.panicf("%s", accept_err)
	}

	fmt.println("Accepted connection from {}", client_endpoint)

	handle_client(client_socket)
}

handle_client :: proc(client_socket: net.TCP_Socket) {
	// loop until the client closes the connection
	for {
		// allocating memory
		data_in_bytes: [8]byte

		// reading data from the client
		_, err := net.recv_tcp(client_socket, data_in_bytes[:])
		if err != nil {
			fmt.panicf("Error reading data from client: %s", err)
		}

		//  "exit" in byte format
		exit_code := [8]byte{101, 120, 105, 116, 13, 10, 0, 0}
		if data_in_bytes == exit_code {
			fmt.println("Connection closed by client")
			break
		}

		// convert byte data to string
		data, e := strings.clone_from_bytes(data_in_bytes[:], context.allocator)
		fmt.println("Received data:", data)
	}
}
