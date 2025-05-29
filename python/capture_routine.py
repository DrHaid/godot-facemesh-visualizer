import socket
import argparse
import cv2

from face_mesh_capture import FaceMeshCapture, convert_landmarks

SOCKET_ADDRESS = ('127.0.0.1', 5052)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-c', '--cam', type=int, dest='cam_index',
                        default=0, help='Index of video capturing device')
    parser.add_argument('-m', '--mock', action='store_true', dest='mock',
                        help='Use "webcam.mp4" to mock webcam. Crashes when video over :(')
    parser.add_argument('-p', '--preview', action='store_true', dest='preview',
                        help='Open preview window with visualized face mesh')
    args = parser.parse_args()

    face_mesh_capture = FaceMeshCapture()
    socket_connection = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    cam = cv2.VideoCapture(
        'webcam.mp4') if args.mock else cv2.VideoCapture(args.cam_index)
    while True:
        success, image = cam.read()

        # loop mock webcam if video is over
        if args.mock and not success:
            cam.set(cv2.CAP_PROP_POS_FRAMES, 0)
            continue

        results = face_mesh_capture.get_face_mesh(image=image)

        data = convert_landmarks(results)
        socket_connection.sendto(data, SOCKET_ADDRESS)

        if args.preview:
            prev = face_mesh_capture.get_preview(image=image, face_mesh=results)
            cv2.imshow('Face Mesh Preview', prev)

        if cv2.waitKey(5) & 0xFF == 27:
            break


if __name__ == "__main__":
    main()
