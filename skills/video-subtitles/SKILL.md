---
name: video-subtitles
description: Generate and check timed subtitles from a local video or audio file, delivering SRT or VTT and optionally a captioned video. Use for requests to transcribe a video into subtitles or add captions to a video.
---

# Video subtitles

Create usable timed subtitles while preserving the source media. Default deliverable: a UTF-8 `.srt` beside the source or in the user's requested output directory. Include `.vtt` when useful; render a captioned video only when requested.

## Workflow

1. Confirm the input exists and has an audio stream with `ffprobe`; note duration. Read any project rules relevant to the source. Do not modify or move the original.
2. Prefer a working local speech-to-text tool that emits segment timestamps. On this Windows host, `whisper` and `ffmpeg` are available; check again before each job. Example PowerShell command: `$env:PYTHONIOENCODING='utf-8'; whisper -f srt --model small --language zh --output_dir '<output-dir>' '<input-video>'`. Use language detection if the language is unclear. For long or noisy material, choose the model based on quality and available compute; tell the user when a model download is needed. Supply only user-confirmed names or terms as vocabulary hints; speculative context can worsen recognition.
3. Preserve the transcription's timing. For Traditional Chinese output, convert only the subtitle text with OpenCC (`s2twp` when appropriate); leave SRT sequence numbers and timestamps intact. Keep an unconverted draft if conversion or wording needs review.
4. Validate the artifact: subtitle count is nonzero; numbering is sequential; timestamps parse, rise in order, and fit the media duration; text is readable and not obviously hallucinated during silence. Sample the beginning, middle, and end against the media where practical. Mark uncertain names, figures, jargon, and low-confidence passages for human review rather than guessing. Never invent timecodes.
5. If requested, create a separate captioned MP4 with `ffmpeg`'s `subtitles` filter and verify its streams and duration. Keep the standalone SRT as well. Do not overwrite the source or an existing output without checking.
6. Return clickable paths for final files, state the source and actual checks performed, and flag any remaining transcription uncertainty. If the user will proofread, label the file `待校` and deliver the editable subtitle promptly. Treat ASR as a draft, especially for technical, medical, legal, political, or course content.

## Boundaries

- Local media stays local unless the user explicitly authorizes uploading it to a service. Do not expose private audio or transcripts in Git or public services.
- A plain transcript is not a timed subtitle. Do not claim subtitle completion unless an SRT or VTT has been created and read back.
- If there is no speech or the audio cannot be decoded, report the finding instead of creating empty or fabricated captions.
