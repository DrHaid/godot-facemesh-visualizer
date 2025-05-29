import struct
from typing import NamedTuple

import cv2
import numpy as np
import mediapipe as mp

MP_FACE_MESH = mp.solutions.face_mesh
MP_DRAWING = mp.solutions.drawing_utils
MP_DRAWING_STYLES = mp.solutions.drawing_styles


class FaceMeshCapture():
    def __init__(self, min_confidence: float = 0.5, max_confidence: float = 0.5) -> None:
        self.detector = MP_FACE_MESH.FaceMesh(
            max_num_faces=1,
            refine_landmarks=True,
            min_detection_confidence=min_confidence,
            min_tracking_confidence=max_confidence)

    def get_face_mesh(self, image: np.array) -> NamedTuple:
        image.flags.writeable = False
        image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
        results = self.detector.process(image)
        if results.multi_face_landmarks:
            return results.multi_face_landmarks[0]

    def get_preview(self, image: np.array, face_mesh: NamedTuple) -> np.array:
        image.flags.writeable = True
        MP_DRAWING.draw_landmarks(
            image=image,
            landmark_list=face_mesh,
            connections=MP_FACE_MESH.FACEMESH_TESSELATION,
            landmark_drawing_spec=None,
            connection_drawing_spec=MP_DRAWING_STYLES.get_default_face_mesh_tesselation_style())
        MP_DRAWING.draw_landmarks(
            image=image,
            landmark_list=face_mesh,
            connections=MP_FACE_MESH.FACEMESH_CONTOURS,
            landmark_drawing_spec=None,
            connection_drawing_spec=MP_DRAWING_STYLES.get_default_face_mesh_contours_style())
        MP_DRAWING.draw_landmarks(
            image=image,
            landmark_list=face_mesh,
            connections=MP_FACE_MESH.FACEMESH_IRISES,
            landmark_drawing_spec=None,
            connection_drawing_spec=MP_DRAWING_STYLES.get_default_face_mesh_iris_connections_style())
        return image


def convert_landmarks(face_mesh: NamedTuple) -> list:
    if not face_mesh:
        return []

    result = [len(face_mesh.landmark)]
    for i, point in enumerate(face_mesh.landmark):
        result.extend((point.x, point.y, point.z))
    return struct.pack('%sf' % len(result), *result)
