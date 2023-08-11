# add_app(
#     APP_NAME test_demo
#     APP_SRCS ./simple_model/test_demo.cpp
#     APP_DEPS simple_model
# )

add_app(
    APP_NAME test_yolo
    APP_SRCS ./test_yolo/test_yolo.cpp
    APP_DEPS yolo_detector
)