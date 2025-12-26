# /// script
# requires-python = ">=3.10"
# dependencies = [
#     "pyautogui",
#     "pynput",
# ]
# ///

import tkinter as tk
from tkinter import messagebox
import pyautogui
import time
import threading
from datetime import datetime, timedelta
from pynput import keyboard

class ScheduledClicker:
    def __init__(self, root):
        self.root = root
        self.root.title("Python 定时任务连点器")
        self.root.geometry("360x320")
        
        self.state = "STOPPED" # 可选值: STOPPED, SCHEDULED, RUNNING
        self.target_time = None
        
        # UI 部分
        # 1. 点击间隔设置
        tk.Label(root, text="--- 基础设置 ---", fg="gray").pack(pady=(10, 5))
        frame_interval = tk.Frame(root)
        frame_interval.pack()
        tk.Label(frame_interval, text="点击间隔 (秒):").pack(side=tk.LEFT)
        self.entry_interval = tk.Entry(frame_interval, width=8, justify='center')
        self.entry_interval.insert(0, "0.01")
        self.entry_interval.pack(side=tk.LEFT, padx=5)

        # 2. 定时启动设置
        tk.Label(root, text="--- 定时启动 (24小时制) ---", fg="gray").pack(pady=(15, 5))
        frame_time = tk.Frame(root)
        frame_time.pack()
        
        # 获取当前时间预填充
        now = datetime.now()
        
        self.entry_h = self.create_time_input(frame_time, now.hour, 24)
        tk.Label(frame_time, text=":").pack(side=tk.LEFT)
        self.entry_m = self.create_time_input(frame_time, (now.minute + 1) % 60, 60)
        tk.Label(frame_time, text=":").pack(side=tk.LEFT)
        self.entry_s = self.create_time_input(frame_time, 0, 60)

        # 3. 按钮区域
        frame_btns = tk.Frame(root)
        frame_btns.pack(pady=15)
        
        self.btn_schedule = tk.Button(frame_btns, text="开启定时任务", command=self.enable_schedule, bg="#e1f5fe")
        self.btn_schedule.pack(side=tk.LEFT, padx=10)
        
        self.btn_stop = tk.Button(frame_btns, text="停止一切 (F1)", command=self.stop_all, fg="red")
        self.btn_stop.pack(side=tk.LEFT, padx=10)

        # 4. 状态显示
        self.status_label = tk.Label(root, text="状态: 就绪", font=("Arial", 14), fg="black")
        self.status_label.pack(pady=10)
        
        self.countdown_label = tk.Label(root, text="", font=("Courier", 12), fg="blue")
        self.countdown_label.pack()

        tk.Label(root, text="全局热键: [F1] 键可随时启动/停止", font=("Arial", 10), fg="gray").pack(side=tk.BOTTOM, pady=10)

        # === 启动监听器 ===
        self.listener = keyboard.Listener(on_press=self.on_key_press)
        self.listener.start()

    def create_time_input(self, parent, default_val, max_val):
        """辅助函数：创建时间输入框"""
        entry = tk.Entry(parent, width=4, justify='center')
        entry.insert(0, f"{default_val:02d}")
        entry.pack(side=tk.LEFT)
        return entry


    def on_key_press(self, key):
        """F1 热键逻辑"""
        if key == keyboard.Key.f1:
            if self.state == "STOPPED":
                # F1 按下时，如果没有设置定时，则直接开始连点（使用当前输入框的间隔）
                self.start_clicking_immediately()
            else:
                # 如果正在倒计时，或者正在连点，F1 统一视为停止
                self.stop_all()
    def enable_schedule(self):
        """点击“开启定时任务”按钮"""
        if self.state != "STOPPED":
            return
        try:
            # 1. 获取并校验时间
            h = int(self.entry_h.get())
            m = int(self.entry_m.get())
            s = int(self.entry_s.get())
            # 简单的逻辑构建目标时间对象
            now = datetime.now()
            target = now.replace(hour=h, minute=m, second=s, microsecond=0)
            
            # 如果设定的时间已经过了（比如现在 10点，设了 9点），自动认为是明天
            if target <= now:
                target += timedelta(days=1)
            self.target_time = target
            self.state = "SCHEDULED"
            # 启动倒计时线程
            threading.Thread(target=self.schedule_loop, daemon=True).start()
            
        except ValueError:
            messagebox.showerror("错误", "时间输入格式有误！")

    def start_clicking_immediately(self):
        try:
            interval = float(self.entry_interval.get())
            self.state = "RUNNING"
            self.update_gui_status("正在疯狂连点中!!!", "green", "")
            threading.Thread(target=self.click_loop, args=(interval,), daemon=True).start()
        except ValueError:
            messagebox.showerror("错误", "间隔必须是数字！")

    def stop_all(self):
        self.state = "STOPPED"
        self.update_gui_status("状态: 已停止", "red", "")


    def schedule_loop(self):
        """倒计时线程"""
        while self.state == "SCHEDULED":
            now = datetime.now()
            remaining = self.target_time - now
            # 检查是否到达时间
            if remaining.total_seconds() <= 0:
                self.root.after(0, self.start_clicking_immediately)
                break
            # 更新倒计时 UI
            self.update_gui_status(f"等待启动...", "blue", f"倒计时: {str(remaining).split('.')[0]}")
            time.sleep(0.1)

    def click_loop(self, interval):
        """点击执行线程"""
        click = pyautogui.click
        sleep = time.sleep
        
        while self.state == "RUNNING":
            click()
            if interval > 0:
                sleep(interval)

    def update_gui_status(self, status_text, color, sub_text):
        def _update():
            self.status_label.config(text=status_text, fg=color)
            self.countdown_label.config(text=sub_text)
        self.root.after(0, _update)

if __name__ == "__main__":
    pyautogui.PAUSE = 0
    root = tk.Tk()
    app = ScheduledClicker(root)
    root.mainloop()