#include <mpi.h>
#include <stdio.h>

int main(int argc, char** argv) {
    MPI_Init(NULL, NULL);

//    // Get the number of processes
//    int world_size;
//    MPI_Comm_size(MPI_COMM_WORLD, &world_size);
//
//    // Get the rank of the process
//    int world_rank;
//    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);
//
//    // Get the name of the processor
//    char processor_name[MPI_MAX_PROCESSOR_NAME];
//    int name_len;
//    MPI_Get_processor_name(processor_name, &name_len);
//
//    // Print off a hello world message
//    printf("Hello world from processor %s, rank %d out of %d processors\n",
//           processor_name, world_rank, world_size);

    int world_rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);
    int world_size;
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);

//    int number;
//    if (world_rank == 0) {
//        number = -1;
//        MPI_Send(&number, 1, MPI_INT, 1, 0, MPI_COMM_WORLD);
//    } else if (world_rank == 1) {
//        MPI_Recv(&number, 1, MPI_INT, 0, 0, MPI_COMM_WORLD,
//                 MPI_STATUS_IGNORE);
//        printf("Process 1 received number %d from process 0\n",
//               number);
//    }


//    int PING_PONG_LIMIT = 14;
//    int ping_pong_count = 10;
//    int partner_rank = (world_rank + 1) % 2;
//    while (ping_pong_count < PING_PONG_LIMIT) {
//        if (world_rank == ping_pong_count % 2) {
//            // Increment the ping pong count before you send it
//            ping_pong_count++;
//            MPI_Send(&ping_pong_count, 1, MPI_INT, partner_rank, 0,
//                     MPI_COMM_WORLD);
//            printf("%d => %d \n", world_rank, ping_pong_count, partner_rank);
//        } else {
//            MPI_Recv(&ping_pong_count, 1, MPI_INT, partner_rank, 0,
//                     MPI_COMM_WORLD, MPI_STATUS_IGNORE);
//            printf("%d <= %d\n",
//                   world_rank, ping_pong_count, partner_rank);
//        }
//        printf("-------------------------\n");
//    }

    int token;
    if (world_rank != 0) {
        MPI_Recv(&token, 1, MPI_INT, world_rank - 1, 0,
                 MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        printf("Process %d received token %d from process %d\n",
               world_rank, token, world_rank - 1);
    } else {
        // Set the token's value if you are process 0
        token = 0;
    }
    token++;
    MPI_Send(&token, 1, MPI_INT, (world_rank + 1) % world_size,
             0, MPI_COMM_WORLD);

    // Now process 0 can receive from the last process.
    if (world_rank == 0) {
        MPI_Recv(&token, 1, MPI_INT, world_size - 1, 0,
                 MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        printf("Process %d received token %d from process %d\n",
               world_rank, token, world_size - 1);
    }

    // Finalize the MPI environment.
    MPI_Finalize();
}
